global class TLSCipherSuiteEventCondition implements TxnSecurity.EventCondition {

    public boolean evaluate(SObject event) {
        switch on event {
            when LoginEvent loginEvent {
                return evaluate(loginEvent);
            }
            when else {
                return false;
            }
        }
    }

    private boolean evaluate(LoginEvent loginEvent) {
        if (String.isBlank(loginEvent.CipherSuite)) return false;

        Set<String> allowedSuites = new Set<String>();
        for (Allowed_Cipher_Suite__mdt suite : [
            SELECT Cipher_Suite__c FROM Allowed_Cipher_Suite__mdt
        ]) {
            allowedSuites.add(suite.Cipher_Suite__c);
        }

        return !allowedSuites.contains(loginEvent.CipherSuite);
    }
}