public class ListViewEventSubscriberV1 implements EventBus.PlatformEventSubscriber {

    // This method processes the platform event.
    public void onSubscribe(List<EventBus.PlatformEvent> events) {
        
        // Debug statement to confirm the subscriber has fired
        System.debug('*** ListViewEventSubscriberV1: onSubscribe method started. Number of events: ' + events.size());

        List<RecordAccessLog__c> logsToInsert = new List<RecordAccessLog__c>();

        for (EventBus.PlatformEvent event : events) {
            
            // The getPayload() method returns the event's data as a generic object,
            // which needs to be cast to the specific event type.
            ListViewEvent listViewEvent = (ListViewEvent)event.getPayload(ListViewEvent.class);
            
            System.debug('--- Processing new ListViewEvent record: ' + listViewEvent.Id);
            System.debug('--- ListViewEvent.Records value: ' + listViewEvent.Records);
            System.debug('--- ListViewEvent.UserId value: ' + listViewEvent.UserId);
            System.debug('--- ListViewEvent.EventDate value: ' + listViewEvent.EventDate);
            
            if (String.isNotBlank(listViewEvent.Records)) {
                
                DateTime eventDate = listViewEvent.EventDate;
                String records = listViewEvent.Records;
                String userId = listViewEvent.UserId;
                
                List<String> recordIds = records.split(',');
                
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
                System.debug('--- ListViewEvent record with Id ' + listViewEvent.Id + ' has no Records value. Skipping.');
            }
        }

        System.debug('*** Number of RecordAccessLog__c records to insert: ' + logsToInsert.size());

        if (!logsToInsert.isEmpty()) {
            try {
                System.debug('*** Attempting to insert logs...');
                insert logsToInsert;
                System.debug('*** Successfully inserted ' + logsToInsert.size() + ' RecordAccessLog__c records.');
            } catch (Exception e) {
                System.debug('*** Error inserting RecordAccessLog__c records: ' + e.getMessage());
            }
        } else {
            System.debug('*** No logs to insert. DML operation skipped.');
        }
        
        System.debug('*** ListViewEventSubscriberV1: onSubscribe method finished.');
    }
}