# Example Usage

To use this module create a file in your terraform directory and use the following code like this [file](../producer.tf) and update the source according to the path where you are keeping the modules.

```terraform
module "lakeformation_permissions_share_data_to_consumer" {
  source     = "./DSH-PRODUCER/"

  database_name            = var.database_name
  catalog_id               = var.catalog_id
  data_sharing_config_file = "${path.module}/data-sharing-config/config.yaml"
}
```

Make sure your config file path is correct while using the module/pattern

Config file example

```yaml
consumer_accounts:
  - consumer_account_id: "xxxxxxxxxxxx"
    consumer_account_name: Consumer
    share_all_tables: false
    tables_to_share:
    - Table
    - Table

  - consumer_account_id: "xxxxxxxxxxxx"
    consumer_account_name: Consumer
    share_all_tables: true
```
