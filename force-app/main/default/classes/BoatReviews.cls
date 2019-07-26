public with sharing class BoatReviews {
    /**
     * returns the list of all the boat reviews related to the boat selected in the "friends with boat" lightning app. 
     */
    @AuraEnabled
    public static List<BoatReview__c> getAll(Id boatId){
        return [SELECT Id, Name, Comment__c, Rating__c, LastModifiedDate, CreatedDate, CreatedBy.Name, CreatedBy.SmallPhotoUrl, CreatedBy.CompanyName FROM BoatReview__c where Boat__c = :boatId];
    }
}