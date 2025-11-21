#!/bin/bash

echo "Checking foreign databases and resource links..."

# Get all foreign databases in consumer account
foreign_dbs=$(aws glue get-databases --resource-share-type FOREIGN --query 'DatabaseList[].Name' --output text 2>/dev/null || echo "")

# Get all resource links in consumer account
resource_links=$(aws glue get-databases --query 'DatabaseList[?TargetDatabase].{Name:Name,Target:TargetDatabase.DatabaseName}' --output json)

# Flag to track if anything was deleted
deleted=false

# Check for orphaned resource links
echo "$resource_links" | jq -r '.[] | "\(.Name)|\(.Target)"' | while IFS='|' read -r link_name target_db; do
    echo "Checking resource link: $link_name, target: $target_db"
    # Check if foreign database still exists
    foreign_exists=$(echo "$foreign_dbs" | grep -w "$target_db" || echo "")
    
    # Check naming pattern: link_name should be "linked_<target_db>"
    expected_link_name="linked_${target_db}"

    if [ -z "$foreign_exists" ]; then
        echo "Foreign DB missing: $target_db, deleting resource link: $link_name"
        aws glue delete-database --name "$link_name"
        deleted=true
    elif [[ "$link_name" != "$expected_link_name" ]]; then
        echo "Invalid naming pattern: $link_name (expected: $expected_link_name), deleting resource link"
        aws glue delete-database --name "$link_name"
        deleted=true
    fi
done

if [ "$deleted" = true ]; then
    echo "Completed cleanup of orphaned resource links."
else
    echo "Nothing to delete - all good!"
fi
