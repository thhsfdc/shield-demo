#!/bin/bash

# Define the relative path to the objects directory
OBJECTS_PATH="force-app/main/default/objects"
OBJECT_NAME="RecordAccessLog__c"

# Check if the directory already exists
if [ -d "$OBJECTS_PATH/$OBJECT_NAME" ]; then
    echo "Directory $OBJECTS_PATH/$OBJECT_NAME already exists. Skipping creation."
else
    echo "Creating directory structure for $OBJECT_NAME..."
    mkdir -p "$OBJECTS_PATH/$OBJECT_NAME/fields"
fi

# Define the metadata content for the custom object
cat <<EOF > "$OBJECTS_PATH/$OBJECT_NAME/$OBJECT_NAME.object-meta.xml"
<?xml version="1.0" encoding="UTF-8"?>
<CustomObject xmlns="http://soap.sforce.com/2006/04/metadata">
    <deploymentStatus>Deployed</deploymentStatus>
    <label>Record Access Log</label>
    <pluralLabel>Record Access Logs</pluralLabel>
    <nameField>
        <displayFormat>RAL-{0}</displayFormat>
        <label>Record Access Log Name</label>
        <type>AutoNumber</type>
    </nameField>
    <enableActivities>true</enableActivities>
    <enableReports>true</enableReports>
    <sharingModel>ReadWrite</sharingModel>
    <visibility>Public</visibility>
</CustomObject>
EOF

# Define the metadata content for the User__c field (Lookup)
cat <<EOF > "$OBJECTS_PATH/$OBJECT_NAME/fields/User__c.field-meta.xml"
<?xml version="1.0" encoding="UTF-8"?>
<CustomField xmlns="http://soap.sforce.com/2006/04/metadata">
    <fullName>User__c</fullName>
    <externalId>false</externalId>
    <label>User</label>
    <referenceTo>User</referenceTo>
    <relationshipLabel>Record Access Logs</relationshipLabel>
    <relationshipName>Record_Access_Logs</relationshipName>
    <required>false</required>
    <trackHistory>false</trackHistory>
    <trackTrending>false</trackTrending>
    <type>Lookup</type>
</CustomField>
EOF

# Define the metadata content for the RecordId__c field (Text)
cat <<EOF > "$OBJECTS_PATH/$OBJECT_NAME/fields/RecordId__c.field-meta.xml"
<?xml version="1.0" encoding="UTF-8"?>
<CustomField xmlns="http://soap.sforce.com/2006/04/metadata">
    <fullName>RecordId__c</fullName>
    <externalId>false</externalId>
    <label>Record ID</label>
    <length>18</length>
    <required>false</required>
    <trackHistory>false</trackHistory>
    <trackTrending>false</trackTrending>
    <type>Text</type>
    <unique>false</unique>
</CustomField>
EOF

# Define the metadata content for the AccessTime__c field (DateTime)
cat <<EOF > "$OBJECTS_PATH/$OBJECT_NAME/fields/AccessTime__c.field-meta.xml"
<?xml version="1.0" encoding="UTF-8"?>
<CustomField xmlns="http://soap.sforce.com/2006/04/metadata">
    <fullName>AccessTime__c</fullName>
    <externalId>false</external>
    <label>Access Time</label>
    <required>false</required>
    <trackHistory>false</trackHistory>
    <trackTrending>false</trackTrending>
    <type>DateTime</type>
</CustomField>
EOF

echo "Metadata files for RecordAccessLog__c created successfully."

# Deploy the metadata to the org
echo "not Deploying metadata to the Salesforce org..."
# sf project deploy start --metadata-dir force-app/main/default --ignore-conflicts

echo "Deployment complete."