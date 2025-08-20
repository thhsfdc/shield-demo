public with sharing class LogMultipleRecordAccess {

    @InvocableMethod(label='Log Accessed Record IDs from ListView Event')
    public static void logAccess(List<InputWrapper> inputs) {
        List<RecordAccessLog__c> logs = new List<RecordAccessLog__c>();

        for (InputWrapper input : inputs) {
            String recordsJson = input.RecordsField;
            try {
                Map<String, Object> parsed = (Map<String, Object>) JSON.deserializeUntyped(recordsJson);
                List<Object> records = (List<Object>) parsed.get('records');

                for (Object recordObj : records) {
                    Map<String, Object> recordMap = (Map<String, Object>) recordObj;
                    String recordId = (String) recordMap.get('Id');

                    if (recordId != null) {
                        logs.add(new RecordAccessLog__c(
                            User__c = input.UserId,
                            RecordId__c = recordId,
                            AccessTime__c = input.EventDate
                        ));
                    }
                }

            } catch (Exception e) {
                System.debug('Failed to parse ListViewEvent Records JSON: ' + e.getMessage());
            }
        }

        if (!logs.isEmpty()) {
            insert logs;
        }
    }

    public class InputWrapper {
        @InvocableVariable(required=true)
        public String RecordsField; // The ListViewEvent.Records field (raw JSON)

        @InvocableVariable(required=true)
        public Id UserId; // The ListViewEvent.UserId

        @InvocableVariable(required=true)
        public Datetime EventDate; // The ListViewEvent.EventDate
    }
}