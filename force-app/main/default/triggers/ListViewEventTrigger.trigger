// Define the trigger to subscribe to the ListViewEvent
trigger ListViewEventTrigger on ListViewEvent (after insert) {
    ListViewEventHandler.handleListViewEvent(Trigger.new);
}
