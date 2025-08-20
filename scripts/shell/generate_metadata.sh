#!/bin/bash

# This script generates the necessary metadata files for the
# Allowed_Cipher_Suite__mdt custom metadata type and its records.

# --- Variables ---
# The Salesforce project root directory
PROJECT_ROOT="$HOME/Documents/mulesoft/customer_topics/coop-uk/devops/vscode/shield-org"

# --- Create Directories ---
echo "Creating metadata directories..."
mkdir -p "$PROJECT_ROOT/force-app/main/default/customMetadata"
mkdir -p "$PROJECT_ROOT/force-app/main/default/customMetadata/Allowed_Cipher_Suite__mdt"


# --- Create Custom Metadata Type File ---
echo "Creating Allowed_Cipher_Suite__mdt metadata file..."
cat << EOF > "$PROJECT_ROOT/force-app/main/default/customMetadata/Allowed_Cipher_Suite__mdt.md-meta.xml"
<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadataType xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>Allowed Cipher Suite</label>
    <protected>false</protected>
    <fields>
        <fullName>Cipher_Suite__c</fullName>
        <externalId>false</externalId>
        <label>Cipher Suite</label>
        <length>255</length>
        <required>true</required>
        <type>Text</type>
        <unique>false</unique>
    </fields>
</CustomMetadataType>
EOF


# --- Create Custom Metadata Record File ---
echo "Creating AES256_GCM metadata record file..."
cat << EOF > "$PROJECT_ROOT/force-app/main/default/customMetadata/Allowed_Cipher_Suite__mdt/AES256_GCM.md-meta.xml"
<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <fullName>Allowed_Cipher_Suite__mdt.AES256_GCM</fullName>
    <label>AES256 GCM</label>
    <protected>false</protected>
    <values>
        <field>Cipher_Suite__c</field>
        <value xsi:type="xsd:string">ECDHE-RSA-AES256-GCM-SHA384</value>
    </values>
</CustomMetadata>
EOF

echo "Metadata files created successfully in your Salesforce DX project."