output "shared_database_info" {
    description = "List of shared databases for consumers"
    value = module.lakeformation_resource_link_creation.shared_database_info
}

output "linked_database_info" {
    description = "List of shared databases for consumers"
    value = module.lakeformation_resource_link_creation.linked_database_info
}