
variable "data_sharing_config_file" {
  type        = string
  description = "The location of the config file to this module"
}

variable "catalog_id" {
  type        = string
  description = "catalog ID of the database to be shared with consumer account"
}

variable "database_name" {
  type        = string
  description = "Name of the database to be shared"
  validation {
    condition     = !startswith(var.database_name, "linked_")
    error_message = "Database name should not start with linked_ prefix"
  }
}