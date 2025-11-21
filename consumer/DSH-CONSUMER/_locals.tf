locals {
  aws_account_id = data.aws_caller_identity.current.id

  config_file = yamldecode(file(var.data_sharing_config_file))
  producer_account_ids = [ for account in local.config_file.producer_accounts : account.producer_account_id ]

  # Read databases from file and parse as JSON (to maintain original structure)
  databases_raw = try(jsondecode(file("/tmp/terraform_databases.json")), [])
  databases     = { for db in local.databases_raw : db.Name => db }
}