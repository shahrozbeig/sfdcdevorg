/**
 * @name orderTrigger
 * @description
**/
trigger orderTrigger on Order (after insert, after update, after undelete) {
    /* if(Trigger.isInsert) {
        if(Trigger.isBefore) {
            //Doing nothing
        }
        if(Trigger.isAfter) {
            OrderHelper.AfterUpdate(Trigger.new, Trigger.old);
        }
    } */

    if(Trigger.isUpdate) {
        if(Trigger.isBefore) {
            //Doing nothing
        }

        if(Trigger.isAfter) {
            OrderHelper.AfterUpdate(Trigger.new, Trigger.old);
        }
    }

    /* if(Trigger.isUndelete) {
        if(Trigger.isBefore) {
            //Doing nothing
        }

        if(Trigger.isAfter) {
            OrderHelper.afterUndelete(Trigger.new);
        }
    }

    if(Trigger.isDelete) {
        if(Trigger.isBefore) {
            //Nothing
        }
        
        if(Trigger.isAfter) {
            OrderHelper.afterDelete( Trigger.old);
        }

    } */
}