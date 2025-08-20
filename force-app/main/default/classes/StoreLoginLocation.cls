public with sharing class StoreLoginLocation {

    @InvocableMethod(label='Store Login Info')
    public static void storeLoginInfo(List<LoginEventWrapper> loginEvents) {
        List<LoginLocation__c> loginRecords = new List<LoginLocation__c>();
        System.debug('Storing login information for ' + loginEvents.size() + ' events.');


        for (LoginEventWrapper e : loginEvents) {
            loginRecords.add(new LoginLocation__c(
                User__c = e.UserId,
                IPAddress__c = e.SourceIp,
                City__c = e.LoginGeoCity,
                Country__c = e.LoginGeoCountry,
                LoginTime__c = e.LoginTime
            ));
        }

        if (!loginRecords.isEmpty()) {
            database.insert(loginRecords, false);
            System.debug('Inserted ' + loginRecords.size() + ' login records.');
        }
    }

    public class LoginEventWrapper {
        @InvocableVariable(label='User Id')
        public Id UserId;

        @InvocableVariable(label='Source IP')
        public String SourceIp;

        @InvocableVariable(label='City')
        public String LoginGeoCity;

        @InvocableVariable(label='Country')
        public String LoginGeoCountry;

        @InvocableVariable(label='Login Time')
        public Datetime LoginTime;
    }
}