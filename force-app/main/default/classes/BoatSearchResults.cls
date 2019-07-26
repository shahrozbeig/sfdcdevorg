public with sharing class BoatSearchResults {
    @AuraEnabled
    public static Boat__c[] getBoats(String boatTypeId){
        System.debug('List: ' + boatTypeId);
        if(boatTypeId != null && boatTypeId != '') {
            return [SELECT Id, Name, Contact__c, Contact__r.Name, BoatType__c, Length__c, Picture__c, Price__c, Year_Built__c FROM Boat__c WHERE BoatType__c = :boatTypeId];
        } else {
            return [SELECT Id, Name, Contact__c, Contact__r.Name, BoatType__c, Length__c, Picture__c, Price__c, Year_Built__c FROM Boat__c];
        }
        // return [SELECT Id, Name, Contact__c, Picture__c, Price__c, Year_Built__c FROM Boat__c ];
    }

    /** 
     * @name getBoatTypes
     * @description return the list "Boat Type" which is renred as the picklist values on "Friends with Boat" lightning app
    **/
    @AuraEnabled
    public static BoatType__c[] getBoatTypes(){
        System.debug('List: ' + [SELECT Id, Name FROM BoatType__c]);
        return [SELECT Id, Name FROM BoatType__c];
    }
}