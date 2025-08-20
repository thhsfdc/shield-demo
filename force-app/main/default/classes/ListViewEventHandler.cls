// Define the class to handle the ListViewEvent
public class ListViewEventHandler {
    // Method to handle the ListViewEvent
    @InvocableMethod
    public static void handleListViewEvent(List<ListViewEvent> events) {

        // --- Debug: Entry point of the method ---
        System.debug('*** ListViewEventHandler: Invocable method handleListViewEvent started. Number of events: ' + events.size());

        List<RecordAccessLog__c> logsToInsert = new List<RecordAccessLog__c>();

        for (ListViewEvent event : events) {
            
            // --- Debug: Processing each event ---
            System.debug('--- Processing new ListViewEvent record: ' + event.Id);
            System.debug('--- Event.Records value: ' + event.Records);
            System.debug('--- Event.UserId value: ' + event.UserId);
            System.debug('--- Event.EventDate value: ' + event.EventDate);

            // Validate that we have the necessary data
            if (String.isNotBlank(event.Records)) {
                
                // Get the event details from the Flow input
                DateTime eventDate = event.EventDate;
                String records = event.Records;
                String userId = event.UserId;
                
                // Process the comma-separated list of record IDs
                List<String> recordIds = records.split(',');
                
                // --- Debug: Split record IDs ---
                System.debug('--- Split Record IDs: ' + recordIds);

                for (String recordId : recordIds) {
                    RecordAccessLog__c log = new RecordAccessLog__c(
                        User__c = userId,
                        RecordId__c = recordId,
                        AccessTime__c = eventDate
                    );
                    logsToInsert.add(log);
                }
            } else {
                // --- Debug: Handle events without records ---
                System.debug('--- ListViewEvent record with Id ' + event.Id + ' has no Records value. Skipping.');
            }
        }
        
        // --- Debug: Check if there are logs to insert ---
        System.debug('*** Number of RecordAccessLog__c records to insert: ' + logsToInsert.size());

        // Insert the new log records, but only if the list is not empty
        if (!logsToInsert.isEmpty()) {
            try {
                // --- Debug: Performing DML operation ---
                System.debug('*** Attempting to insert logs...');
                insert logsToInsert;
                // --- Debug: Successful DML ---
                System.debug('*** Successfully inserted ' + logsToInsert.size() + ' RecordAccessLog__c records.');

            } catch (Exception e) {
                // Log the exception to the debug log for troubleshooting
                System.debug('*** Error inserting RecordAccessLog__c records: ' + e.getMessage());
            }
        } else {
            // --- Debug: No logs to insert ---
            System.debug('*** No logs to insert. DML operation skipped.');
        }
        
        // --- Debug: Exit point of the method ---
        System.debug('*** ListViewEventHandler: Invocable method handleListViewEvent finished.');
    }
}