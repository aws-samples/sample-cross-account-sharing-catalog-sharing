#!/bin/bash

# Check if SOURCE_ACCOUNT_ID is set
if [ -z "$SOURCE_ACCOUNT_ID" ]; then
    echo "Warning: SOURCE_ACCOUNT_ID not set. Will accept all pending LakeFormation invitations."
    FILTER_BY_ACCOUNT=false
else
    echo "Using SOURCE_ACCOUNT_ID: $SOURCE_ACCOUNT_ID"
    FILTER_BY_ACCOUNT=true
fi

# Get pending resource share invitations
echo "Checking for pending RAM resource share invitations..."

invitations=$(aws ram get-resource-share-invitations --query 'resourceShareInvitations[?status==`PENDING`]' --output json)

if [ "$invitations" = "[]" ]; then
    echo "No pending invitations found."
    exit 0
fi

# Process each pending invitation
echo "$invitations" | jq -r '.[] | @base64' | while IFS= read -r invitation; do
    invitation_data=$(echo "$invitation" | base64 --decode)
    
    resource_share_name=$(echo "$invitation_data" | jq -r '.resourceShareName // ""')
    sender_account_id=$(echo "$invitation_data" | jq -r '.senderAccountId // ""')
    invitation_arn=$(echo "$invitation_data" | jq -r '.resourceShareInvitationArn // ""')
    
    # Accept LakeFormation invitations based on account filtering
    if [[ "$resource_share_name" == LakeFormation* ]]; then
        if [ "$FILTER_BY_ACCOUNT" = true ] && [[ "$sender_account_id" == "$SOURCE_ACCOUNT_ID" ]]; then
            echo "Accepting invitation: $resource_share_name from Account ID: $sender_account_id"
            aws ram accept-resource-share-invitation --resource-share-invitation-arn "$invitation_arn"
        elif [ "$FILTER_BY_ACCOUNT" = false ]; then
            echo "Accepting invitation: $resource_share_name from Account ID: $sender_account_id"
            aws ram accept-resource-share-invitation --resource-share-invitation-arn "$invitation_arn"
        else
            echo "Skipping invitation: $resource_share_name from Account ID: $sender_account_id (account mismatch)"
        fi
    else
        echo "Skipping invitation: $resource_share_name from Account ID: $sender_account_id (not LakeFormation)"
    fi
done

echo "Completed processing RAM invitations."
