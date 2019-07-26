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

    public static void rollUpOrderItems(Set<Id> activatedOrderIds){
        // a Map named "productMap" of Ids to Product2 records which will be used update Product Quantity and update dml on its values.
        Map<Id, Product2> productMap;

        List<OrderItem> orderItems = [SELECT Id, Product2Id, OrderId, Quantity from OrderItem WHERE OrderId IN :activatedOrderIds];
        Set<Id> productIdsSet = new Set<Id>();

        if(orderItems.size()>0) {
            for (OrderItem oi : orderItems) {
                productIdsSet.add(oi.Product2Id);
            }
        }

        productMap = new Map<Id,Product2>([SELECT Id, Name FROM Product2 WHERE Id IN :productIdsSet]);

        if(productMap.size() > 0 && productMap != null) {
            for (AggregateResult ar : [SELECT Product2id, sum(Quantity) from OrderItem WHERE Product2.Id IN :productMap.keyset() GROUP BY Product2id ]) {
                productMap.get((String)ar.get('Product2id')).Quantity_Ordered__c = Integer.valueOf(ar.get('expr0'));
            }
            update productMap.values();
        }
    }

}