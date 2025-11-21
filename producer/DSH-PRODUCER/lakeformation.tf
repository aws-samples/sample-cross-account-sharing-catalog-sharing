resource "aws_lakeformation_permissions" "share_database_to_consumers" {
  for_each  = local.consumer_account_config
  principal = each.value.consumer_account_id

  permissions = ["DESCRIBE"]
  database {
    name       = var.database_name
    catalog_id = var.catalog_id
  }
  permissions_with_grant_option = ["DESCRIBE"]
}

resource "aws_lakeformation_permissions" "share_tables_to_consumers" {
  for_each  = local.consumer_account_config
  principal = each.value.consumer_account_id

  permissions = ["SELECT", "DESCRIBE"]
  dynamic "table" {
    for_each = each.value.share_all_tables ? [1] : local.consumer_account_config[each.key].tables_to_share
    content {
      database_name = var.database_name
      catalog_id    = var.catalog_id

      # when sharing all tables, use wildcard - Otherwise, specify table name
      name     = each.value.share_all_tables ? null : table.value
      wildcard = each.value.share_all_tables ? "true" : null
    }
  }
  permissions_with_grant_option = ["SELECT", "DESCRIBE"]
}