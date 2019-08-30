public with sharing class BatchApexErrorTriggerHandler {

    public static void handleFailedLeadConverts(List<BatchApexErrorEvent> listofApexErrorEvents) {
        List<BatchLeadConvertErrors__c> leadConvertErrorList = new List<BatchLeadConvertErrors__c>();
        for (BatchApexErrorEvent eventrecord : listofApexErrorEvents) {
            BatchLeadConvertErrors__c leadConvertError = new BatchLeadConvertErrors__c();
            leadConvertError.AsyncApexJobId__c = eventrecord.AsyncApexJobId;
            leadConvertError.Records__c = eventrecord.JobScope;
            leadConvertError.StackTrace__c = eventrecord.StackTrace;
            leadConvertErrorList.add(leadConvertError);
        }
        if(!leadConvertErrorList.isEmpty()) {
            Database.insert(leadConvertErrorList, false);
        }
    }
}