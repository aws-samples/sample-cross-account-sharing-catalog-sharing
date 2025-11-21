module "lakeformation_resource_link_creation" {
  source = "./DSH-CONSUMER"
  data_sharing_config_file = "${path.module}/data-sharing-config/config.yaml"
}
