trigger BatchApexErrorTrigger on BatchApexErrorEvent (after insert) {
	if(Trigger.isInsert) {
        if(Trigger.isAfter) {
            BatchApexErrorTriggerHandler.handleFailedLeadConverts(Trigger.new);
        }
    }
}