# Example Usage

To use this module create a file in your terraform directory and use the following code like this [file](../consumer_link.tf) and update the source according to the path where you are keeping the modules.

```terraform
module "lakeformation_resource_link_creation" {
  source = "./DSH-CONSUMER"
  data_sharing_config_file = "${path.module}/data-sharing-config/config.yaml"
}
```

Make sure your config file path is correct while using the module/pattern

Config file example

```yaml
producer_accounts:
  - producer_account_id: "xxxxxxxxxxxx"
    producer_account_name: Producer

  - producer_account_id: "xxxxxxxxxxxx"
    producer_account_name: Producer
```
