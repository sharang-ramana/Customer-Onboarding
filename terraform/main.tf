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
resource "confluent_kafka_cluster" "basic" {
  display_name = "Terraform_Dev"
  availability = "SINGLE_ZONE"
  cloud        = "AWS"
  region       = "us-east-2"
  basic {}

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
  crn_pattern = confluent_kafka_cluster.basic.rbac_crn
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
    id          = confluent_kafka_cluster.basic.id
    api_version = confluent_kafka_cluster.basic.api_version
    kind        = confluent_kafka_cluster.basic.kind

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
    id = confluent_kafka_cluster.basic.id
  }
  topic_name         = "customer"
  partitions_count   = 6
  rest_endpoint = confluent_kafka_cluster.basic.rest_endpoint
  credentials {
    key    = confluent_api_key.app-manager-kafka-kafka-api-key.id
    secret = confluent_api_key.app-manager-kafka-kafka-api-key.secret
  }
}

resource "confluent_kafka_topic" "events" {
  kafka_cluster {
    id = confluent_kafka_cluster.basic.id
  }
  topic_name         = "events"
  partitions_count   = 6
  rest_endpoint = confluent_kafka_cluster.basic.rest_endpoint
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

# Configure Connector
resource "confluent_connector" "postgres-db-sink" {
  environment {
      id = confluent_environment.development.id
  }
  kafka_cluster {
    id = confluent_kafka_cluster.basic.id
  }

  
  config_sensitive = {
    "connection.password" = var.postgres_password,
  }

  
  config_nonsensitive = {
        "topics" = confluent_kafka_topic.customer.topic_name,
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
        "pk.fields" = "event_id",
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
    depends_on = [ confluent_kafka_topic.customer ]
}