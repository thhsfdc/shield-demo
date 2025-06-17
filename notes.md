Setup notes:

root path
    /Users/thoeger/Documents/mulesoft/customer_topics/coop-uk/devops/vscode

- initilize sfdx project




- Github repo:
    https://github.com/thhsfdc/shield-demo

git statuactions  after 
  git add *
  git add .
  git status
  git commit -m "Initial commit of Salesforce project"
  git remote -v
  git remote add origin https://github.com/thhsfdc/shield-demo.git
  git remote -v
  git push -u origin main

set default org - update the file sfdx-project.json with the MyDomain Name

10:10:33.795 sf org:login:web --alias shield-demo --instance-url https://storm-480268b59e3655.my.salesforce.com/ --set-default

execute this to generate package.xml:
  sf project generate --name force-app --default-package-dir force-app --manifest




  sf org:login:web --alias shield-devsb --instance-url https://storm-480268b59e3655--dev.sandbox.my.salesforce.com

  sf org:login:web --alias shield-devprosb --instance-url https://storm-480268b59e3655--devpro.sandbox.my.salesforce.com

sf org list

  🍁 │         │ shield-demo       │ thoeger-cdosec@salesforce.com        │ 00DHu00000SJkxHMAT │ Connected                                                            │
│    │ Sandbox │ shield-devprosb   │ thoeger-cdosec@salesforce.com.devpro │ 00DD30000001VUTMA2 │ Connected                                                            │
│    │ Sandbox │ shield-devsb      │ thoeger-cdosec@salesforce.com.dev    │ 00DD30000008sFeMAI │ Connected                                                            │
└────┴─────────┴───────────────────┴──────────────────────────────────────┴────────────────────┴──────────────────────────────────────────────────────────────────────┘


sf project retrieve preview --target-org shield-devsb

Will Retrieve [28] files.
┌───────────────────────────┬─────────────────────────────────────────┬──────┐
│ Type                      │ Full Name                               │ Path │
├───────────────────────────┼─────────────────────────────────────────┼──────┤
│ ListView                  │ DemoInfoObject__c.All                   │      │
│ CustomField               │ DemoInfoObject__c.description__c        │      │
│ CustomField               │ DemoInfoObject__c.Account_Lookup__c     │      │
│ Profile                   │ Admin                                   │      │
│ Profile                   │ Salesforce API Only System Integrations │      │
│ Profile                   │ B2B Reordering Portal Buyer Profile     │      │
│ Layout                    │ DemoInfoObject__c-DemoInfoObject Layout │      │
│ CustomObject              │ DemoInfoObject__c                       │      │
│ CustomTab                 │ DemoInfoObject__c                       │      │
│ TransactionSecurityPolicy │ TransactionpolicyInfo                   │      │
│ TransactionSecurityPolicy │ apexpolicy                              │      │
│ PermissionSet             │ OmniPresenceStatusPermissionSet         │      │
│ PermissionSet             │ sfdcInternalInt__sfdc_activityplatform  │      │
│ PermissionSet             │ sfdcInternalInt__sfdc_fieldservice      │      │
│ PermissionSet             │ EventLogObjects                         │      │
│ PermissionSet             │ sfdc_aiplanner_service_permset          │      │
│ PermissionSet             │ SDO_PlatformSecurity_EncryptionKeys     │      │
│ PermissionSet             │ SDO_PlatformSecurity_SCM                │      │
│ PermissionSet             │ API_access                              │      │
│ PermissionSet             │ sf_devops_NamedCredentials              │      │
│ PermissionSet             │ sf_devops_InitializeEnvironments        │      │
│ PermissionSet             │ CDO_Base_Permission                     │      │
│ PermissionSet             │ xDO_Base_QBrix_Register                 │      │
│ PermissionSet             │ PDW_Permission_set                      │      │
│ PermissionSet             │ SDO_Data_Tool                           │      │
│ PermissionSet             │ SDO_Tooling_Access                      │      │
│ PermissionSet             │ sfdcInternalInt__sfdc_scrt2             │      │
│ PermissionSet             │ sfdc_chatbot_service_permset            │      │
└───────────────────────────┴─────────────────────────────────────────┴──────┘
