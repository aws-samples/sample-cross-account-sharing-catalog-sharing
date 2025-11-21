output "shared_database_info" {
  description = "List of shared databases for consumers"
  value = [
    for shared_db in local.databases : {
      account_id = shared_db.CatalogId
      db_name    = shared_db.Name
    }
  ]
}

output "linked_database_info" {
  description = "Map of linked database keys to their catalog ID and name created in consumer account"
  value = {
    for linked_db_name, linked_db in aws_glue_catalog_database.linked_databases : linked_db_name => {
      linked_db_name       = linked_db.name
      linked_db_catalog_id = linked_db.catalog_id
    }
  }
}
