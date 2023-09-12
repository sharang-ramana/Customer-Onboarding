resource "confluent_environment" "development" {
  display_name = "Development"
}

# Stream Governance and Kafka clusters can be in different regions as well as different cloud providers,
# but you should to place both in the same cloud and region to restrict the fault isolation boundary.
data "confluent_schema_registry_region" "essentials" {
  cloud   = "AWS"
  region  = "us-east-2"
  package = "ESSENTIALS"
}

resource "confluent_schema_registry_cluster" "essentials" {
  package = data.confluent_schema_registry_region.essentials.package

  environment {
    id = confluent_environment.development.id
  }

  region {
    # See https://docs.confluent.io/cloud/current/stream-governance/packages.html#stream-governance-regions
    id = data.confluent_schema_registry_region.essentials.id
  }
}

#This part creates cluster inside environment
resource "confluent_kafka_cluster" "standard" {
  display_name = "Terraform_Dev"
  availability = "SINGLE_ZONE"
  cloud        = "AWS"
  region       = "us-east-2"
  standard {}

  environment {
    
  id=confluent_environment.development.id
 
  }
}

##This part creates service account

resource "confluent_service_account" "app-manager-kafka" {
  display_name = "app-manager-kafka"
  description  = "Service account to manage 'inventory' Kafka cluster"
}

resource "confluent_role_binding" "app-manager-kafka-kafka-cluster-admin" {
  principal   = "User:${confluent_service_account.app-manager-kafka.id}"
  role_name   = "CloudClusterAdmin"
  crn_pattern = confluent_kafka_cluster.standard.rbac_crn
}

resource "confluent_api_key" "app-manager-kafka-kafka-api-key" {
  display_name = "app-manager-kafka-kafka-api-key"
  description  = "Kafka API Key that is owned by 'app-manager-kafka' service account"
  owner {
    id          = confluent_service_account.app-manager-kafka.id
    api_version = confluent_service_account.app-manager-kafka.api_version
    kind        = confluent_service_account.app-manager-kafka.kind
  }

  managed_resource {
    id          = confluent_kafka_cluster.standard.id
    api_version = confluent_kafka_cluster.standard.api_version
    kind        = confluent_kafka_cluster.standard.kind

    environment {
      id = confluent_environment.development.id
    }
  }

  # The goal is to ensure that confluent_role_binding.app-manager-kafka-kafka-cluster-admin is created before
  # confluent_api_key.app-manager-kafka-kafka-api-key is used to create instances of
  # confluent_kafka_topic, confluent_kafka_acl resources.

  # 'depends_on' meta-argument is specified in confluent_api_key.app-manager-kafka-kafka-api-key to avoid having
  # multiple copies of this definition in the configuration which would happen if we specify it in
  # confluent_kafka_topic, confluent_kafka_acl resources instead.
  depends_on = [
    confluent_role_binding.app-manager-kafka-kafka-cluster-admin
  ]
}

resource "confluent_kafka_topic" "customer" {
  kafka_cluster {
    id = confluent_kafka_cluster.standard.id
  }
  topic_name         = "customer"
  partitions_count   = 6
  rest_endpoint = confluent_kafka_cluster.standard.rest_endpoint
  credentials {
    key    = confluent_api_key.app-manager-kafka-kafka-api-key.id
    secret = confluent_api_key.app-manager-kafka-kafka-api-key.secret
  }
}

resource "confluent_kafka_topic" "customer_enriched" {
  kafka_cluster {
    id = confluent_kafka_cluster.standard.id
  }
  topic_name         = "customer_enriched"
  partitions_count   = 6
  rest_endpoint = confluent_kafka_cluster.standard.rest_endpoint
  credentials {
    key    = confluent_api_key.app-manager-kafka-kafka-api-key.id
    secret = confluent_api_key.app-manager-kafka-kafka-api-key.secret
  }
}

resource "confluent_kafka_topic" "events" {
  kafka_cluster {
    id = confluent_kafka_cluster.standard.id
  }
  topic_name         = "events"
  partitions_count   = 6
  rest_endpoint = confluent_kafka_cluster.standard.rest_endpoint
  credentials {
    key    = confluent_api_key.app-manager-kafka-kafka-api-key.id
    secret = confluent_api_key.app-manager-kafka-kafka-api-key.secret
  }
}

#Setup Schema Registry
resource "confluent_service_account" "env-manager" {
  display_name = "env-manager"
  description  = "Service account to manage 'Development' environment"
}

resource "confluent_role_binding" "env-manager-environment-admin" {
  principal   = "User:${confluent_service_account.env-manager.id}"
  role_name   = "EnvironmentAdmin"
  crn_pattern = confluent_environment.development.resource_name
}

resource "confluent_api_key" "env-manager-schema-registry-api-key" {
  display_name = "env-manager-schema-registry-api-key"
  description  = "Schema Registry API Key that is owned by 'env-manager' service account"
  owner {
    id          = confluent_service_account.env-manager.id
    api_version = confluent_service_account.env-manager.api_version
    kind        = confluent_service_account.env-manager.kind
  }

  managed_resource {
    id          = confluent_schema_registry_cluster.essentials.id
    api_version = confluent_schema_registry_cluster.essentials.api_version
    kind        = confluent_schema_registry_cluster.essentials.kind

    environment {
      id = confluent_environment.development.id
    }
  }

  # The goal is to ensure that confluent_role_binding.env-manager-environment-admin is created before
  # confluent_api_key.env-manager-schema-registry-api-key is used to create instances of
  # confluent_schema resources.

  # 'depends_on' meta-argument is specified in confluent_api_key.env-manager-schema-registry-api-key to avoid having
  # multiple copies of this definition in the configuration which would happen if we specify it in
  # confluent_schema resources instead.
  depends_on = [
    confluent_role_binding.env-manager-environment-admin
  ]
}

# setup KSQL
// ksqlDB service account with only the necessary access
resource "confluent_service_account" "ksql-manager" {
  display_name = "ksql-manager"
  description  = "Service account for Ksql cluster"
}

resource "confluent_ksql_cluster" "main" {
  display_name = "ksql_cluster_0"
  csu = 1
  kafka_cluster {
    id = confluent_kafka_cluster.standard.id
  }
  credential_identity {
    id = confluent_service_account.ksql-manager.id
  }
  environment {
    id = confluent_environment.development.id
  }

  depends_on = [
    confluent_schema_registry_cluster.essentials,
    confluent_role_binding.ksql-manager-schema-registry-resource-owner
  ]
}

resource "confluent_kafka_acl" "ksql-manager-describe-on-cluster" {
  kafka_cluster {
    id = confluent_kafka_cluster.standard.id
  }
  resource_type = "CLUSTER"
  resource_name = "kafka-cluster"
  pattern_type  = "LITERAL"
  principal     = "User:${confluent_service_account.ksql-manager.id}"
  host          = "*"
  operation     = "DESCRIBE"
  permission    = "ALLOW"
  rest_endpoint = confluent_kafka_cluster.standard.rest_endpoint
  credentials {
    key    = confluent_api_key.app-manager-kafka-kafka-api-key.id
    secret = confluent_api_key.app-manager-kafka-kafka-api-key.secret
  }
}

resource "confluent_kafka_acl" "ksql-manager-describe-on-topic" {
  kafka_cluster {
    id = confluent_kafka_cluster.standard.id
  }
  resource_type = "TOPIC"
  resource_name = "*"
  pattern_type  = "LITERAL"
  principal     = "User:${confluent_service_account.ksql-manager.id}"
  host          = "*"
  operation     = "DESCRIBE"
  permission    = "ALLOW"
  rest_endpoint = confluent_kafka_cluster.standard.rest_endpoint
  credentials {
    key    = confluent_api_key.app-manager-kafka-kafka-api-key.id
    secret = confluent_api_key.app-manager-kafka-kafka-api-key.secret
  }
}

resource "confluent_kafka_acl" "ksql-manager-describe-on-group" {
  kafka_cluster {
    id = confluent_kafka_cluster.standard.id
  }
  resource_type = "GROUP"
  resource_name = "*"
  pattern_type  = "LITERAL"
  principal     = "User:${confluent_service_account.ksql-manager.id}"
  host          = "*"
  operation     = "DESCRIBE"
  permission    = "ALLOW"
  rest_endpoint = confluent_kafka_cluster.standard.rest_endpoint
  credentials {
    key    = confluent_api_key.app-manager-kafka-kafka-api-key.id
    secret = confluent_api_key.app-manager-kafka-kafka-api-key.secret
  }
}

resource "confluent_kafka_acl" "ksql-manager-describe-configs-on-cluster" {
  kafka_cluster {
    id = confluent_kafka_cluster.standard.id
  }
  resource_type = "CLUSTER"
  resource_name = "kafka-cluster"
  pattern_type  = "LITERAL"
  principal     = "User:${confluent_service_account.ksql-manager.id}"
  host          = "*"
  operation     = "DESCRIBE_CONFIGS"
  permission    = "ALLOW"
  rest_endpoint = confluent_kafka_cluster.standard.rest_endpoint
  credentials {
    key    = confluent_api_key.app-manager-kafka-kafka-api-key.id
    secret = confluent_api_key.app-manager-kafka-kafka-api-key.secret
  }
}

resource "confluent_kafka_acl" "ksql-manager-describe-configs-on-topic" {
  kafka_cluster {
    id = confluent_kafka_cluster.standard.id
  }
  resource_type = "TOPIC"
  resource_name = "*"
  pattern_type  = "LITERAL"
  principal     = "User:${confluent_service_account.ksql-manager.id}"
  host          = "*"
  operation     = "DESCRIBE_CONFIGS"
  permission    = "ALLOW"
  rest_endpoint = confluent_kafka_cluster.standard.rest_endpoint
  credentials {
    key    = confluent_api_key.app-manager-kafka-kafka-api-key.id
    secret = confluent_api_key.app-manager-kafka-kafka-api-key.secret
  }
}

resource "confluent_kafka_acl" "ksql-manager-describe-configs-on-group" {
  kafka_cluster {
    id = confluent_kafka_cluster.standard.id
  }
  resource_type = "GROUP"
  resource_name = "*"
  pattern_type  = "LITERAL"
  principal     = "User:${confluent_service_account.ksql-manager.id}"
  host          = "*"
  operation     = "DESCRIBE_CONFIGS"
  permission    = "ALLOW"
  rest_endpoint = confluent_kafka_cluster.standard.rest_endpoint
  credentials {
    key    = confluent_api_key.app-manager-kafka-kafka-api-key.id
    secret = confluent_api_key.app-manager-kafka-kafka-api-key.secret
  }
}

resource "confluent_kafka_acl" "ksql-manager-describe-on-transactional-id" {
  kafka_cluster {
    id = confluent_kafka_cluster.standard.id
  }
  resource_type = "TRANSACTIONAL_ID"
  resource_name = confluent_ksql_cluster.main.topic_prefix
  pattern_type  = "LITERAL"
  principal     = "User:${confluent_service_account.ksql-manager.id}"
  host          = "*"
  operation     = "DESCRIBE"
  permission    = "ALLOW"
  rest_endpoint = confluent_kafka_cluster.standard.rest_endpoint
  credentials {
    key    = confluent_api_key.app-manager-kafka-kafka-api-key.id
    secret = confluent_api_key.app-manager-kafka-kafka-api-key.secret
  }
}

resource "confluent_kafka_acl" "ksql-manager-write-on-transactional-id" {
  kafka_cluster {
    id = confluent_kafka_cluster.standard.id
  }
  resource_type = "TRANSACTIONAL_ID"
  resource_name = confluent_ksql_cluster.main.topic_prefix
  pattern_type  = "LITERAL"
  principal     = "User:${confluent_service_account.ksql-manager.id}"
  host          = "*"
  operation     = "WRITE"
  permission    = "ALLOW"
  rest_endpoint = confluent_kafka_cluster.standard.rest_endpoint
  credentials {
    key    = confluent_api_key.app-manager-kafka-kafka-api-key.id
    secret = confluent_api_key.app-manager-kafka-kafka-api-key.secret
  }
}

resource "confluent_kafka_acl" "ksql-manager-all-on-topic-prefix" {
  kafka_cluster {
    id = confluent_kafka_cluster.standard.id
  }
  resource_type = "TOPIC"
  resource_name = confluent_ksql_cluster.main.topic_prefix
  pattern_type  = "PREFIXED"
  principal     = "User:${confluent_service_account.ksql-manager.id}"
  host          = "*"
  operation     = "ALL"
  permission    = "ALLOW"
  rest_endpoint = confluent_kafka_cluster.standard.rest_endpoint
  credentials {
    key    = confluent_api_key.app-manager-kafka-kafka-api-key.id
    secret = confluent_api_key.app-manager-kafka-kafka-api-key.secret
  }
}

resource "confluent_kafka_acl" "ksql-manager-all-on-topic-confluent" {
  kafka_cluster {
    id = confluent_kafka_cluster.standard.id
  }
  resource_type = "TOPIC"
  resource_name = "_confluent-ksql-${confluent_ksql_cluster.main.topic_prefix}"
  pattern_type  = "PREFIXED"
  principal     = "User:${confluent_service_account.ksql-manager.id}"
  host          = "*"
  operation     = "ALL"
  permission    = "ALLOW"
  rest_endpoint = confluent_kafka_cluster.standard.rest_endpoint
  credentials {
    key    = confluent_api_key.app-manager-kafka-kafka-api-key.id
    secret = confluent_api_key.app-manager-kafka-kafka-api-key.secret
  }
}

resource "confluent_kafka_acl" "ksql-manager-all-on-group-confluent" {
  kafka_cluster {
    id = confluent_kafka_cluster.standard.id
  }
  resource_type = "GROUP"
  resource_name = "_confluent-ksql-${confluent_ksql_cluster.main.topic_prefix}"
  pattern_type  = "PREFIXED"
  principal     = "User:${confluent_service_account.ksql-manager.id}"
  host          = "*"
  operation     = "ALL"
  permission    = "ALLOW"
  rest_endpoint = confluent_kafka_cluster.standard.rest_endpoint
  credentials {
    key    = confluent_api_key.app-manager-kafka-kafka-api-key.id
    secret = confluent_api_key.app-manager-kafka-kafka-api-key.secret
  }
}

# Topic specific permissions. You have to add an ACL like this for every Kafka topic you work with.
resource "confluent_kafka_acl" "ksql-manager-all-on-topic" {
  kafka_cluster {
    id = confluent_kafka_cluster.standard.id
  }
  resource_type = "TOPIC"
  resource_name = confluent_kafka_topic.customer.topic_name
  pattern_type  = "PREFIXED"
  principal     = "User:${confluent_service_account.ksql-manager.id}"
  host          = "*"
  operation     = "ALL"
  permission    = "ALLOW"
  rest_endpoint = confluent_kafka_cluster.standard.rest_endpoint
  credentials {
    key    = confluent_api_key.app-manager-kafka-kafka-api-key.id
    secret = confluent_api_key.app-manager-kafka-kafka-api-key.secret
  }
}

resource "confluent_kafka_acl" "ksql-manager-for-customer_enriched-topic" {
  kafka_cluster {
    id = confluent_kafka_cluster.standard.id
  }
  resource_type = "TOPIC"
  resource_name = confluent_kafka_topic.customer_enriched.topic_name
  pattern_type  = "PREFIXED"
  principal     = "User:${confluent_service_account.ksql-manager.id}"
  host          = "*"
  operation     = "ALL"
  permission    = "ALLOW"
  rest_endpoint = confluent_kafka_cluster.standard.rest_endpoint
  credentials {
    key    = confluent_api_key.app-manager-kafka-kafka-api-key.id
    secret = confluent_api_key.app-manager-kafka-kafka-api-key.secret
  }
}

resource "confluent_role_binding" "ksql-manager-schema-registry-resource-owner" {
  principal   = "User:${confluent_service_account.ksql-manager.id}"
  role_name   = "ResourceOwner"
  crn_pattern = format("%s/%s", confluent_schema_registry_cluster.essentials.resource_name, "subject=*")
}

# ACLs are needed for KSQL service account to read/write data from/to kafka, this role instead is needed for giving
# access to the Ksql cluster.
resource "confluent_role_binding" "ksql-manager-ksql-admin" {
  principal   = "User:${confluent_service_account.ksql-manager.id}"
  role_name   = "KsqlAdmin"
  crn_pattern = confluent_ksql_cluster.main.resource_name
}

resource "confluent_api_key" "ksql-manager-db-api-key" {
  display_name = "ksql-manager-db-api-key"
  description  = "KsqlDB API Key that is owned by 'ksql-manager' service account"
  owner {
    id          = confluent_service_account.ksql-manager.id
    api_version = confluent_service_account.ksql-manager.api_version
    kind        = confluent_service_account.ksql-manager.kind
  }

  managed_resource {
    id          = confluent_ksql_cluster.main.id
    api_version = confluent_ksql_cluster.main.api_version
    kind        = confluent_ksql_cluster.main.kind

    environment {
      id = confluent_environment.development.id
    }
  }
}


# Configure Connector
resource "confluent_connector" "postgres-db-sink" {
  environment {
      id = confluent_environment.development.id
  }
  kafka_cluster {
    id = confluent_kafka_cluster.standard.id
  }

  
  config_sensitive = {
    "connection.password" = var.postgres_password,
  }

  
  config_nonsensitive = {
        "topics" = "${confluent_kafka_topic.customer.topic_name},${confluent_kafka_topic.customer_enriched.topic_name}",
        "schema.context.name" = "default",
        "input.data.format" = "JSON_SR",
        "input.key.format" = "STRING",
        "delete.enabled" = "false",
        "connector.class" = "PostgresSink",
        "name" = "PostgresSinkConnector_1",
        "kafka.auth.mode" = "KAFKA_API_KEY",
        "kafka.api.key" = confluent_api_key.app-manager-kafka-kafka-api-key.id,
        "kafka.api.secret" = confluent_api_key.app-manager-kafka-kafka-api-key.secret,
        "connection.host" = var.postgres_host,
        "connection.port" = var.postgres_port,
        "connection.user" = var.postgres_user,
        "db.name" = var.postgres_db_name,
        "ssl.mode" = "prefer",
        "insert.mode" = "INSERT",
        "table.types" = "TABLE",
        "db.timezone" = "UTC",
        "pk.fields" = "email_id",
        "auto.create" = "false",
        "auto.evolve" = "false",
        "quote.sql.identifiers" = "ALWAYS",
        "batch.sizes" = "3000",
        "max.poll.interval.ms" = "300000",
        "max.poll.records" = "500",
        "tasks.max" = "1",
        "transforms" = "transform_0",
        "transforms.transform_0.type" = "org.apache.kafka.connect.transforms.TimestampConverter$Value",
        "transforms.transform_0.target.type" = "Date",
        "transforms.transform_0.field" = "dob"
    }
    depends_on = [ confluent_kafka_topic.customer, confluent_kafka_topic.customer_enriched ]
}