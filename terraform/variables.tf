variable "confluent_cloud_api_key" {
  description = "Confluent Cloud API Key (also referred as Cloud API ID)"
  type        = string
  default = " "   #Add your API Key created during pre-requsite
}

variable "confluent_cloud_api_secret" {
  description = "Confluent Cloud API Secret"
  type        = string
  sensitive   = true
  default = " "   #Add your API secret created during pre-requsite
}

variable "postgres_host" {
  description = "Add your Postgres Host"
  type        = string
  default = " " #Add your postgres host here
}

variable "postgres_port" {
  description = "Add your Postgres port"
  type        = string
  default = " " #Add your postgres port here
}

variable "postgres_user" {
  description = "Add your Postgres user"
  type        = string
  default = " " #Add your postgres user here
}

variable "postgres_password" {
  description = "Add your Postgres password"
  type        = string
  sensitive   = true
  default = " " #Add your postgres password here
}

variable "postgres_db_name" {
  description = "Add your Postgres DB name"
  type        = string
  default = " " #Add your postgres database name here
}