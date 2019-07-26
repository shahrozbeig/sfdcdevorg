trigger CalculateContacts on Contact (after insert, before insert, after update, after delete, before update) {
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            CalculateContactsHandler.handleContactCountOnInsertion(Trigger.new, Trigger.newMap);
            CalculateContactsHandler.calculateAmountOnContactOnInsert(Trigger.new, Trigger.newMap);
        }

        if(Trigger.isUpdate){
            CalculateContactsHandler.handleContactCountOnUpdate(Trigger.new, Trigger.newMap, Trigger.oldMap);
            CalculateContactsHandler.calculateAmountOnContactOnUpdate(Trigger.new, Trigger.newMap, Trigger.oldMap);
        }

        if(Trigger.isDelete){
            CalculateContactsHandler.handleContactCountOnDeletion(Trigger.old, Trigger.oldMap);
        }
    }

    if(Trigger.isBefore) {
        if(Trigger.isInsert){
            ContactInvestmentHandler.checkDupeInvestmentEmail(Trigger.new);
        }

        if(Trigger.isUpdate){
            ContactInvestmentHandler.checkDupeInvestmentEmail(Trigger.new);
        }
    }
}