locals {

  config_file = yamldecode(file(var.data_sharing_config_file))

  consumer_account_config = {
    for account in local.config_file.consumer_accounts :
    account.consumer_account_id => {
      consumer_account_id = account.consumer_account_id
      consumer_account_name = account.consumer_account_name
      share_all_tables = account.share_all_tables
      tables_to_share = share_all_tables ? [] : account.tables_to_share
    }
  }
}