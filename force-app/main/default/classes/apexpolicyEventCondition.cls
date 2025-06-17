global class apexpolicyEventCondition implements TxnSecurity.EventCondition {

    public boolean evaluate(SObject event) {
        // Cast the generic SObject event to a more specific type if needed.
        // For API access to Contact, the event type will likely be 'ApiEvent'.
        // You'll need to inspect the 'event' SObject to determine its exact structure
        // based on the transaction security event type you choose when configuring the policy.

        // Example: Assuming the event is an ApiEvent and we want to check for Contact access by an API user.
        // You might need to adjust the field names based on the actual event object structure.
        // To find the exact structure, you can inspect the 'event' SObject during debugging
        // or refer to Salesforce documentation on Transaction Security Event Monitoring.
		System.debug('apexpolicyEventCondition started ' + event);
        if (event instanceof ApiEvent) {
            ApiEvent apiEvent = (ApiEvent) event;

            // Check if the user is an API user (e.g., using 'isApi' or checking profile/permission set)
            // A common way to identify an API user is if their session type is 'API'.
            // However, Transaction Security events often provide more direct ways to identify API access.

            // Let's assume the ApiEvent has a field like 'Operation' and 'EntityType'
            // and we want to trigger on 'Query' or 'Retrieve' operations on 'Contact'.

            // You'll need to confirm the exact field names available on ApiEvent.
            // Common fields for API events might include:
            // - ApiType: e.g., 'SOAP', 'REST', 'BULK'
            // - Operation: e.g., 'Query', 'Retrieve', 'Create', 'Update', 'Delete'
            // - EntityName: The object being accessed, e.g., 'Contact'
            // - UserId: The ID of the user performing the API call

            // For demonstration purposes, let's make some assumptions about the ApiEvent fields.
            // **IMPORTANT: You MUST verify these field names against actual ApiEvent objects
            // captured by Transaction Security for accurate results.**

            String entityName = (String) apiEvent.get('ENTITY_NAME'); // Common field, but verify
            String operation = (String) apiEvent.get('OPERATION');   // Common field, but verify
            String apiType = (String) apiEvent.get('API_TYPE');       // Common field, but verify

            // Check if the entity is Contact and the operation is a read operation (query/retrieve)
            if ('Contact'.equalsIgnoreCase(entityName) &&
                ('Query'.equalsIgnoreCase(operation) || 'Retrieve'.equalsIgnoreCase(operation)) &&
                apiType != null // Ensure apiType is not null
               ) {
                // You can add more specific checks here if needed,
                // e.g., checking the user's profile or permission set
                // to ensure they are specifically an "API User" in your definition.
                // However, the ApiEvent itself implies API access.

                // If you need to check the user's profile/permission set:
                // User apiUser = [SELECT Profile.Name FROM User WHERE Id = :apiEvent.get('USER_ID') LIMIT 1];
                // if (apiUser.Profile.Name.contains('API User Profile Name')) {
                //    return true;
                // }

                System.debug('Transaction Policy Triggered: API User accessing Contact record.');
                return true; // Condition met: invoke the policy
            }
        }
        return false; // Condition not met
    }
}