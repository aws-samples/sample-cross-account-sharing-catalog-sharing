# Example Usage

```terraform
module "lakeformation_resource_link_creation" {
  source = "./DSH-CONSUMER"
  data_sharing_config_file = "${path.module}/data-sharing-config/config.yaml"
}
```

Make sure your config file path is correct while using the module/pattern

config file example

```yaml
producer_accounts:
  - producer_account_id: "xxxxxxxxxxxx"
    producer_account_name: Producer

  - producer_account_id: "xxxxxxxxxxxx"
    producer_account_name: Producer
```
