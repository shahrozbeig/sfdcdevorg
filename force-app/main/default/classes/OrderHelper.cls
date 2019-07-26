public without sharing class OrderHelper {

    /**
     * @name AfterUpdate
     * @description 
     * @param List<Order> newList
     * @param List<Order> oldList
     * @return void
    **/
    public static void afterUpdate(List<Order> newList, List<Order> oldList){
        Set<Id> activatedOrderIds = new Set<Id>();
        for ( Integer i=0; i<newList.size(); i++ ){
            if ( newList[i].Status == Constants.ACTIVATED_ORDER_STATUS && oldList[i].Status != Constants.ACTIVATED_ORDER_STATUS ){
                activatedOrderIds.add(newList[i].Id);
            }
        }
        rollUpOrderItems(activatedOrderIds);
    }

    /**
     * @name AfterUpdate
     * @description 
     * @param List<Order> oldList
     * @return void
    **/
    // public static void afterDelete(List<Order> oldList){
    //     Set<Id> activatedOrderIds = new Set<Id>();
    //     for ( Integer i=0; i<oldList.size(); i++ ){
    //         if ( oldList[i].Status != Constants.ACTIVATED_ORDER_STATUS ){
    //             activatedOrderIds.add(oldList[i].Id);
    //         }
    //     }
    //     rollUpOrderItems(activatedOrderIds);
    // }

    // /**
    //  * @name AfterUpdate
    //  * @description 
    //  * @param List<Order> newList
    //  * @return void
    // **/
    // public static void afterUndelete(List<Order> newList){
    //     Set<Id> activatedOrderIds = new Set<Id>();
    //     for ( Integer i=0; i<newList.size(); i++ ){
    //         if ( newList[i].Status == Constants.ACTIVATED_ORDER_STATUS ){
    //             activatedOrderIds.add(newList[i].Id);
    //         }
    //     }
    //     rollUpOrderItems(activatedOrderIds);
    // }

    /**
     * @name RollUpOrderItems
     * @description Given a set of Activated Order ids, query the child Order Items and related Products to calculate Inventory levels
     * @param Set<Id> activatedOrderIds
     * @return void
    **/
    public static void rollUpOrderItems(Set<Id> activatedOrderIds){
        //ToDo: Declare a Map named "productMap" of Ids to Product2 records
        Map<Id, Product2> productMap;

        //ToDo: Loop through a query of OrderItems related to the activatedOrderIds
        List<OrderItem> orderItems = [SELECT Id, Product2Id, OrderId, Quantity from OrderItem WHERE OrderId IN :activatedOrderIds];
        Set<Id> productIdsSet = new Set<Id>();

        if(orderItems.size()>0) {
            for (OrderItem oi : orderItems) {
                productIdsSet.add(oi.Product2Id);
            }
        }

        //ToDo: Populate the map with the Id of the related Product2 as the key and Product2 record as the value
        productMap = new Map<Id,Product2>([SELECT Id, Name FROM Product2 WHERE Id IN :productIdsSet]);

        //ToDo: Loop through a query that aggregates the OrderItems related to the Products in the ProductMap keyset
        //ToDo: Perform an update on the records in the productMap
        if(productMap.size() > 0 && productMap != null) {
            for (AggregateResult ar : [SELECT Product2id, sum(Quantity) from OrderItem WHERE Product2.Id IN :productMap.keyset() GROUP BY Product2id ]) {
                productMap.get((String)ar.get('Product2id')).Quantity_Ordered__c = Integer.valueOf(ar.get('expr0'));
            }
            update productMap.values();
        }
    }

}