public with sharing class CalculateContactsHandler {
    public CalculateContactsHandler() {
    }
    
    public static void handleContactCountOnInsertion(List<Contact> newContacts, Map<id, Contact> newContactsMap){
        Map<Id, Account> mapOfParentAccounts;
        Map<Id, Account> mapOfAccountsToUpdate = new Map<Id, Account>();
        Set<Id> setOfNewAccountIds = new Set<Id>();
        for (Contact newContact : newContacts) {
            if(newContact.AccountId != null){
                setOfNewAccountIds.add(newContact.AccountId);
            }
        }
        if(setOfNewAccountIds.size() > 0){
             mapOfParentAccounts = new Map<Id, Account>([SELECT Id, (SELECT Id from Contacts), Total_Contacts__c from Account WHERE Id IN :setOfNewAccountIds]);
        }

        for(Contact newContact : newContacts){
            if(mapOfParentAccounts != null && mapOfParentAccounts.containsKey(newContact.AccountId)){
                System.debug('Count: ' + mapOfParentAccounts.get(newContact.AccountId).Total_Contacts__c);
                // Decimal count = mapOfParentAccounts.get(newContact.AccountId).Total_Contacts__c;
                Decimal count = mapOfParentAccounts.get(newContact.AccountId).contacts.size();
                Account acc = new Account(Id = newContact.AccountId, Total_Contacts__c = count);
                mapOfAccountsToUpdate.put(newContact.AccountId, acc);
            }
        }
        update mapOfAccountsToUpdate.values();

        // we also can use the below logic for the same //
        /* List<AggregateResult> aggResults = [SELECT COUNT(Id), AccountId from Contact where AccountId IN :mapOfParentAccounts.keySet() Group By AccountId];
        for (AggregateResult aggResult : aggResults) {
            Id parentId = (ID)aggResult.get('AccountId');
            if(mapOfParentAccounts.containsKey(parentId)){
                Account acc = mapOfParentAccounts.get(parentId);
                Integer count = (Integer)aggResult.get('expr0');
                acc.Total_Contacts__c = count;
                mapOfParentAccounts.put(parentId, acc);
            }
        }
        update mapOfParentAccounts.values(); */
    }

    public static void handleContactCountOnUpdate(List<Contact> newContacts, Map<Id, Contact> newContactsMap, Map<Id, Contact> oldContactsMap) {
        Set<Id> setOfNewAccIds = new Set<Id>();
        // Set<Id> setOfOldAccIds = new Set<Id>();
        Map<Id, Account> mapOfAccountsToUpdate = new Map<Id, Account>();
        Map<Id, Account> mapOfParentAccounts;
        for (Contact newcontact : newContacts) {
            if(newContactsMap.get(newContact.Id).AccountId != oldContactsMap.get(newContact.Id).AccountId) {
                System.debug('Ayaya');
                setOfNewAccIds.add(newContactsMap.get(newContact.Id).AccountId);
                setOfNewAccIds.add(oldContactsMap.get(newContact.Id).AccountId);
            }
        }

        if (setOfNewAccIds.size() > 0) {
             mapOfParentAccounts = new Map<Id, Account>([SELECT Id, (SELECT Id from Contacts), Total_Contacts__c from Account WHERE Id IN :setOfNewAccIds]);
        }

        for (Contact newContact : newContacts) {
            if (mapOfParentAccounts != null && mapOfParentAccounts.containsKey(newContactsMap.get(newContact.Id).AccountId)) {
                System.debug('Count: ' + mapOfParentAccounts.get(newContact.AccountId).Total_Contacts__c);
                Decimal count = mapOfParentAccounts.get(newContact.AccountId).contacts.size();
                Account acc = new Account(Id = newContact.AccountId, Total_Contacts__c = count);
                mapOfAccountsToUpdate.put(newContact.AccountId, acc);
            }
            if (mapOfParentAccounts != null && mapOfParentAccounts.containsKey(oldContactsMap.get(newContact.Id).AccountId)) {
                System.debug('Count: ' + mapOfParentAccounts.get(oldContactsMap.get(newContact.Id).AccountId).Total_Contacts__c);
                Decimal count = mapOfParentAccounts.get(oldContactsMap.get(newContact.Id).AccountId).contacts.size();
                Account acc = new Account(Id = oldContactsMap.get(newContact.Id).AccountId, Total_Contacts__c = count);
                mapOfAccountsToUpdate.put(oldContactsMap.get(newContact.Id).AccountId, acc);
            }
        }
        update mapOfAccountsToUpdate.values();
    }

    public static void handleContactCountOnDeletion(List<Contact> oldContacts, Map<id, Contact> oldContactsMap){
        Map<Id, Account> mapOfParentAccounts;
        Map<Id, Account> mapOfAccountsToUpdate = new Map<Id, Account>();
        Set<Id> setOfoldAccountIds = new Set<Id>();
        for (Contact oldContact : oldContacts) {
            if(oldContact.AccountId != null){
                setOfoldAccountIds.add(oldContact.AccountId);
            }
        }
        if(setOfoldAccountIds.size() > 0){
             mapOfParentAccounts = new Map<Id, Account>([SELECT Id, Total_Contacts__c from Account WHERE Id IN :setOfoldAccountIds]);
        }

        for(Contact oldContact : oldContacts){
            if(mapOfParentAccounts != null && mapOfParentAccounts.containsKey(oldContact.AccountId)){
                System.debug('Count: ' + mapOfParentAccounts.get(oldContact.AccountId).Total_Contacts__c);
                Decimal count = mapOfParentAccounts.get(oldContact.AccountId).Total_Contacts__c;
                Account acc = new Account(Id = oldContact.AccountId, Total_Contacts__c = count-1);
                mapOfAccountsToUpdate.put(oldContact.AccountId, acc);
            }
        }
        update mapOfAccountsToUpdate.values();
    }

    public static void calculateAmountOnContactOnInsert(List<Contact> newContacts, Map<Id,Contact> newContactsMap) {
        Map<Id, Account> mapOfAccountsToUpdate = new Map<Id, Account>();
        Set<Contact> newContactIdsSet = new Set<Contact>();
        Set<Id> newAccountIdsSet = new Set<Id>();
        for (Contact con : newContacts) {
            newAccountIdsSet.add(con.AccountId);
        }

        List<AggregateResult> conSumResult = [SELECT SUM(Amount_X__c) amtX, SUM(Amount_Y__c) amtY, AccountId from Contact where AccountId != Null AND AccountId IN: newAccountIdsSet GROUP By AccountId];
        for (AggregateResult aggResult : conSumResult) {
            if(aggResult.get('amtX') != null && aggResult.get('amtY') != null) {
                Id parentId = (ID)aggResult.get('AccountId');
                Account acc = new Account(Id = parentId, Roll_up_Amount__c = (Decimal)aggResult.get('amtX') + (Decimal)aggResult.get('amtY'));
                mapOfAccountsToUpdate.put(parentId, acc);
            }
        }
        update mapOfAccountsToUpdate.values();
    }

    public static void calculateAmountOnContactOnUpdate(List<Contact> newContacts, Map<Id, Contact> newContactsMap, Map<Id, Contact> oldContactsMap) {
        Set<Id> accountIdsSet = new Set<Id>();
        Map<Id, Account> mapOfAccountsToUpdate = new Map<Id, Account>();
        for (Contact newContact : newContacts) {
            if(newContactsMap.get(newContact.Id).Amount_X__c != oldContactsMap.get(newContact.Id).Amount_X__c 
                || newContactsMap.get(newContact.Id).Amount_Y__c != oldContactsMap.get(newContact.Id).Amount_Y__c ) {
                accountIdsSet.add(newContactsMap.get(newContact.Id).AccountId);
                accountIdsSet.add(oldContactsMap.get(newContact.Id).AccountId);
            }
        }
        List<AggregateResult> conSumResult = [SELECT SUM(Amount_X__c) amtX, SUM(Amount_Y__c) amtY, AccountId from Contact where AccountId != Null AND AccountId IN: accountIdsSet GROUP By AccountId];
        for (AggregateResult aggResult : conSumResult) {
            if(aggResult.get('amtX') != null && aggResult.get('amtY') != null) {
                Id parentId = (ID)aggResult.get('AccountId');
                Account acc = new Account(Id = parentId, Roll_up_Amount__c = (Decimal)aggResult.get('amtX') + (Decimal)aggResult.get('amtY'));
                mapOfAccountsToUpdate.put(parentId, acc);
            }
        }
        update mapOfAccountsToUpdate.values();

    }
   
}