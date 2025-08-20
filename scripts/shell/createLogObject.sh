#!/bin/bash

# ==============================================================================
# Salesforce Custom Object Metadata Script
#
# Description:
# This script creates the metadata files for a custom object `LoginLocation__c`
# and its associated fields. It's designed to be run from the root of a
# Salesforce DX project.
#
# Object: LoginLocation__c
# Fields:
#   - User__c (Lookup to User)
#   - LoginTime__c (DateTime)
#   - Country__c (Text)
#   - City__c (Text)
#   - IPAddress__c (Text)
#
# Usage:
# 1. Save this script as `create_login_object.sh` in your SFDX project root.
# 2. Open a terminal in your project root.
# 3. Make the script executable: chmod +x create_login_object.sh
# 4. Run the script: ./create_login_object.sh
# ==============================================================================

# --- Configuration ---
# The main path for your package. Adjust if your structure is different.
PACKAGE_PATH="force-app/main/default"
OBJECT_API_NAME="LoginLocation__c"
OBJECT_DIR="$PACKAGE_PATH/objects/$OBJECT_API_NAME"
FIELDS_DIR="$OBJECT_DIR/fields"

# --- Script Execution ---

echo "Starting metadata creation for $OBJECT_API_NAME..."

# Create the necessary directories for the object and its fields
echo "Creating directories..."
mkdir -p "$FIELDS_DIR"
echo "  -> Directory created: $FIELDS_DIR"

# --- Create the Custom Object Metadata File ---
echo "Creating object metadata file: $OBJECT_API_NAME.object-meta.xml"
cat <<EOF > "$OBJECT_DIR/$OBJECT_API_NAME.object-meta.xml"
<?xml version="1.0" encoding="UTF-8"?>
<CustomObject xmlns="http://soap.sforce.com/2006/04/metadata">
    <label>Login Location</label>
    <pluralLabel>Login Locations</pluralLabel>
    <nameField>
        <label>Login Location ID</label>
        <type>AutoNumber</type>
        <displayFormat>LL-{000000}</displayFormat>
    </nameField>
    <deploymentStatus>Deployed</deploymentStatus>
    <sharingModel>ReadWrite</sharingModel>
    <enableActivities>true</enableActivities>
    <enableHistory>true</enableHistory>
    <enableReports>true</enableReports>
    <trackHistory>false</trackHistory>
</CustomObject>
EOF
echo "  -> Object file created successfully."


# --- Create the Custom Field Metadata Files ---

# 1. User__c (Lookup to User)
echo "Creating field: User__c"
cat <<EOF > "$FIELDS_DIR/User__c.field-meta.xml"
<?xml version="1.0" encoding="UTF-8"?>
<CustomField xmlns="http://soap.sforce.com/2006/04/metadata">
    <fullName>User__c</fullName>
    <label>User</label>
    <type>Lookup</type>
    <referenceTo>User</referenceTo>
    <relationshipName>LoginLocations</relationshipName>
    <required>false</required>
    <trackHistory>false</trackHistory>
    <deleteConstraint>SetNull</deleteConstraint>
    <externalId>false</externalId>
</CustomField>
EOF

# 2. LoginTime__c (DateTime)
echo "Creating field: LoginTime__c"
cat <<EOF > "$FIELDS_DIR/LoginTime__c.field-meta.xml"
<?xml version="1.0" encoding="UTF-8"?>
<CustomField xmlns="http://soap.sforce.com/2006/04/metadata">
    <fullName>LoginTime__c</fullName>
    <label>Login Time</label>
    <type>DateTime</type>
    <required>false</required>
    <trackHistory>false</trackHistory>
    <externalId>false</externalId>
</CustomField>
EOF

# 3. Country__c (Text)
echo "Creating field: Country__c"
cat <<EOF > "$FIELDS_DIR/Country__c.field-meta.xml"
<?xml version="1.0" encoding="UTF-8"?>
<CustomField xmlns="http://soap.sforce.com/2006/04/metadata">
    <fullName>Country__c</fullName>
    <label>Country</label>
    <type>Text</type>
    <length>100</length>
    <required>false</required>
    <trackHistory>false</trackHistory>
    <externalId>false</externalId>
    <unique>false</unique>
</CustomField>
EOF

# 4. City__c (Text)
echo "Creating field: City__c"
cat <<EOF > "$FIELDS_DIR/City__c.field-meta.xml"
<?xml version="1.0" encoding="UTF-8"?>
<CustomField xmlns="http://soap.sforce.com/2006/04/metadata">
    <fullName>City__c</fullName>
    <label>City</label>
    <type>Text</type>
    <length>100</length>
    <required>false</required>
    <trackHistory>false</trackHistory>
    <externalId>false</externalId>
    <unique>false</unique>
</CustomField>
EOF

# 5. IPAddress__c (Text)
echo "Creating field: IPAddress__c"
cat <<EOF > "$FIELDS_DIR/IPAddress__c.field-meta.xml"
<?xml version="1.0" encoding="UTF-8"?>
<CustomField xmlns="http://soap.sforce.com/2006/04/metadata">
    <fullName>IPAddress__c</fullName>
    <label>IP Address</label>
    <type>Text</type>
    <length>50</length>
    <required>false</required>
    <trackHistory>false</trackHistory>
    <externalId>false</externalId>
    <unique>false</unique>
</CustomField>
EOF

echo "  -> All field files created successfully."
echo ""
echo "✅ Metadata creation complete. You can now deploy these files to your org."

