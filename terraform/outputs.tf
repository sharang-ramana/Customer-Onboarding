output "resource-ids" {
  value = <<-EOT
  Environment ID:           ${confluent_environment.development.id}
  Kafka Cluster ID:         ${confluent_kafka_cluster.standard.id}
  Kafka topic names:        ${confluent_kafka_topic.customer.topic_name}, ${confluent_kafka_topic.customer_enriched.topic_name}, ${confluent_kafka_topic.credit_score.topic_name}, ${confluent_kafka_topic.events.topic_name}
  Bootstap Server Endpoint: ${confluent_kafka_cluster.standard.bootstrap_endpoint}

  Service Accounts and their Kafka API Keys (API Keys inherit the permissions granted to the owner):
  ${confluent_service_account.app-manager-kafka.display_name}:                         ${confluent_service_account.app-manager-kafka.id}
  ${confluent_service_account.app-manager-kafka.display_name}'s Kafka API Key:        "${confluent_api_key.app-manager-kafka-kafka-api-key.id}"
  ${confluent_service_account.app-manager-kafka.display_name}'s Kafka API Secret:     "${confluent_api_key.app-manager-kafka-kafka-api-key.secret}"

  Schema Registry Details:
  Schema Registry endpoint:                                                            ${confluent_schema_registry_cluster.essentials.rest_endpoint} 
  ${confluent_service_account.env-manager.display_name}:                               ${confluent_service_account.env-manager.id}
  ${confluent_service_account.env-manager.display_name}'s Schema Registry API Key:    "${confluent_api_key.env-manager-schema-registry-api-key.id}"
  ${confluent_service_account.env-manager.display_name}'s Schema Registry API Secret: "${confluent_api_key.env-manager-schema-registry-api-key.secret}"
  
  KSQLDB details:
  ksqlDB Cluster ID:                    ${confluent_ksql_cluster.main.id}
  ksqlDB Cluster API Endpoint:          ${confluent_ksql_cluster.main.rest_endpoint}
  KSQL Service Account ID:              ${confluent_service_account.ksql-manager.id}
  
  EOT

  sensitive = true
}