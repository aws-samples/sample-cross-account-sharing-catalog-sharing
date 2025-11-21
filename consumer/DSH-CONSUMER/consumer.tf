resource "terraform_data" "ram_resource_delete" {

  triggers_replace = [timestamp()]

  provisioner "local-exec" {
    command = "chmod +x ${path.module}/assets/ram_clear.sh"
  }
  provisioner "local-exec" {
    command = "bash ${path.module}/assets/ram_clear.sh"
  }
}

resource "terraform_data" "ram_resource_accept" {
  depends_on = [ terraform_data.ram_resource_delete ]
  for_each = toset(local.producer_account_ids)

  triggers_replace = [timestamp()]

  provisioner "local-exec" {
    command = "chmod +x ${path.module}/assets/ram_accept.sh"
  }
  provisioner "local-exec" {
    command = "bash ${path.module}/assets/ram_accept.sh"
    environment = {
      SOURCE_ACCOUNT_ID = each.value
    }
  }
}

resource "terraform_data" "discover_databases" {
  depends_on = [terraform_data.ram_resource_accept]
  
  triggers_replace = [timestamp()]
  
  provisioner "local-exec" {
    command = "aws glue get-databases --resource-share-type FOREIGN --query 'DatabaseList' --output json > /tmp/terraform_databases.json || echo '[]' > /tmp/terraform_databases.json "
  }
}


resource "aws_glue_catalog_database" "linked_databases" {
  depends_on = [ terraform_data.discover_databases ]
  for_each = local.databases

  name     = "linked_${each.key}"
  target_database {
    catalog_id    = each.value.CatalogId
    database_name = each.key
  }
  lifecycle {
    ignore_changes = [description]
  }
}