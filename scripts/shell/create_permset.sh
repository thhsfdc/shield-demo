#!/bin/bash

# ==============================================================================
# Salesforce Permission Set Metadata Script
#
# Description:
# This script creates the metadata file for a Permission Set that grants
# full access to the `LoginLocation__c` custom object. It's designed to be
# run from the root of a Salesforce DX project.
#
# Permission Set: Login_Location_Admin
# Access:
#   - Object: Full Access (Create, Read, Edit, Delete, View All, Modify All)
#   - Fields: Full Read and Edit access to all fields on LoginLocation__c
#
# Usage:
# 1. Save this script as `create_permset.sh` in your SFDX project root.
# 2. Open a terminal in your project root.
# 3. Make the script executable: chmod +x create_permset.sh
# 4. Run the script: ./create_permset.sh
# ==============================================================================

# --- Configuration ---
# The main path for your package. Adjust if your structure is different.
PACKAGE_PATH="force-app/main/default"
PERMSET_API_NAME="Login_Location_Admin"
PERMSET_DIR="$PACKAGE_PATH/permissionsets"
PERMSET_FILE="$PERMSET_DIR/$PERMSET_API_NAME.permissionset-meta.xml"

# --- Script Execution ---

echo "Starting metadata creation for Permission Set: $PERMSET_API_NAME..."

# Create the necessary directory for the permission set
echo "Creating directory (if it doesn't exist)..."
mkdir -p "$PERMSET_DIR"
echo "  -> Directory ensures existence: $PERMSET_DIR"

# --- Create the Permission Set Metadata File ---
echo "Creating permission set file: $PERMSET_FILE"
cat <<EOF > "$PERMSET_FILE"
<?xml version="1.0" encoding="UTF-8"?>
<PermissionSet xmlns="http://soap.sforce.com/2006/04/metadata">
    <label>Login Location Admin</label>
    <description>Grants full administrative access to the Login Location object and its fields.</description>
    <hasActivationRequired>false</hasActivationRequired>
    
    <!-- Field Level Security -->
    <fieldPermissions>
        <field>LoginLocation__c.User__c</field>
        <editable>true</editable>
        <readable>true</readable>
    </fieldPermissions>
    <fieldPermissions>
        <field>LoginLocation__c.LoginTime__c</field>
        <editable>true</editable>
        <readable>true</readable>
    </fieldPermissions>
    <fieldPermissions>
        <field>LoginLocation__c.Country__c</field>
        <editable>true</editable>
        <readable>true</readable>
    </fieldPermissions>
    <fieldPermissions>
        <field>LoginLocation__c.City__c</field>
        <editable>true</editable>
        <readable>true</readable>
    </fieldPermissions>
    <fieldPermissions>
        <field>LoginLocation__c.IPAddress__c</field>
        <editable>true</editable>
        <readable>true</readable>
    </fieldPermissions>

    <!-- Object Level Security -->
    <objectPermissions>
        <object>LoginLocation__c</object>
        <allowCreate>true</allowCreate>
        <allowDelete>true</allowDelete>
        <allowEdit>true</allowEdit>
        <allowRead>true</allowRead>
        <modifyAllRecords>true</modifyAllRecords>
        <viewAllRecords>true</viewAllRecords>
    </objectPermissions>
</PermissionSet>
EOF
echo "  -> Permission Set file created successfully."
echo ""
echo "✅ Metadata creation complete. You can now deploy this permission set to your org."

