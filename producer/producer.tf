module "share_database_to_consumer" {
  source     = "./DSH-PRODUCER/"

  database_name            = var.database_name
  catalog_id               = var.catalog_id
  data_sharing_config_file = "${path.module}/data-sharing-config/config.yaml"
}
