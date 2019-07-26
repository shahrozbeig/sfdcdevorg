public with sharing class PropertyJunctionHandler {
    @AuraEnabled(Cacheable=true)
    public static Property__c[] getAllProperties(){
        return [SELECT Id, Name, Type__c, Sub_Type__c, (Select contentDocumentId from ContentDocumentLinks) attachedFiles from Property__c];
        // return [SELECT Id, Name, Type__c, Sub_Type__c from Property__c];
    }
}