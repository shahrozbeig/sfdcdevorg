trigger ProjectTrigger on Project__c (after update) {
    if (Trigger.isUpdate) {
        if (Trigger.isAfter) {
            BillingCalloutService.callBillingService(Trigger.new);
        }
    }
}