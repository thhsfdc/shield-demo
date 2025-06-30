@IsTest
private class OrgInfoAPIclassTest {
    @IsTest
    static void testGetOrgInfo() {
        // Set up a mock RestRequest
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/OrgInfoAPI';
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;

        // Call the doGet method
        Test.startTest();
        Map<String, String> responseData = OrgInfoAPIclass.doGet();
        Test.stopTest();

        // Assertions
        System.assert(responseData.containsKey('timestamp'), 'Response should contain a timestamp');
        System.assert(responseData.containsKey('organizationName'), 'Response should contain an organization name');
        System.assert(responseData.containsKey('myDomainUri'), 'Response should contain a My Domain URI');
        System.assert(responseData.containsKey('username'), 'Response should contain a username');
    }
}
