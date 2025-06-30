@RestResource(urlMapping='/OrgInfoAPI/*')
global with sharing class OrgInfoAPIclass {

    @HttpGet
    global static Map<String, String> doGet() {
        Map<String, String> responseData = new Map<String, String>();

        // 1. Get current timestamp with full date, time, and timezone
        Datetime currentDateTime = Datetime.now();
        // Use formatGmt() or format() for consistency, formatLong() can be verbose.
        // formatGMT() ensures it's always in GMT, useful for API consistency.
        String formattedTimestamp = currentDateTime.formatGMT('yyyy-MM-dd HH:mm:ss \'GMT\'');

        responseData.put('timestamp', formattedTimestamp);

        // 2. Get the Organization Name
        Organization org;
        try {
            // Query only for the Name, as SalesforceOrgURL is problematic and IsSandbox might not be needed.
            org = [SELECT Name FROM Organization LIMIT 1];
            responseData.put('organizationName', org.Name);
        } catch (QueryException qe) {
            System.debug('Error retrieving organization name: ' + qe.getMessage());
            responseData.put('organizationName', 'Error: Could not retrieve organization name.');
        }

        // 3. Get the full external MyDomain URI
        String myDomainUrlString = 'Not Available';
        try {
            // Try to use URL.getOrgDomainUrl() which is more robust for My Domain
            URL orgDomainUrl = URL.getOrgDomainUrl();
            if (orgDomainUrl != null) {
                myDomainUrlString = orgDomainUrl.toExternalForm();
            } else {
                // Fallback: Construct it using the base URL if getOrgDomainUrl() is null
                // This might give the instance URL (e.g., na1.salesforce.com) if My Domain isn't fully reflected
                // or if the API version is very old.
                myDomainUrlString = URL.getSalesforceBaseUrl().toExternalForm();
                // In some older orgs, if getOrgDomainUrl is not available,
                // the base URL will likely be the instance URL.
                // For a true My Domain, it should be something like mydomain.my.salesforce.com.
                // We assume if getOrgDomainUrl is null, it's either an older API version or
                // the org is not fully My Domain enabled in a way this method recognizes.
            }
        } catch (Exception e) {
            System.debug('Error retrieving My Domain URL: ' + e.getMessage());
            // If URL.getSalesforceBaseUrl() or URL.getOrgDomainUrl() completely fail (e.g., very old API or unusual context)
            myDomainUrlString = 'Error: Could not retrieve My Domain URL via standard methods.';
        }
        responseData.put('myDomainUri', myDomainUrlString);


        // 4. Get the username of the executing user
        responseData.put('username', UserInfo.getUserName());

        return responseData;
    }
}