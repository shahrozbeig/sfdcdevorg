trigger BillingStateUpdate on Account (before insert, before update) {
    if(trigger.isInsert || trigger.isUpdate) {
        for (Account account : trigger.new) {
            String city = account.BillingCity + '__c';
            Map<String, Object> mapOfBillingCustomSetting = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(Billing_State__c.getInstance()));
            if(mapOfBillingCustomSetting.containsKey(city)) {
                account.BillingState = (String)mapOfBillingCustomSetting.get(city);
            }
        }
    }
}