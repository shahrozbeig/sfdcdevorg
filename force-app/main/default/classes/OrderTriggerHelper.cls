public with sharing class OrderTriggerHelper {
    public static void orderInsertHelper(List<Order> ordersList) {
        List<Product2> productList = new List<Product2>();
        Set<Id> orderSet = new Set<Id>();
        
        for (Order ord : ordersList) {
           orderSet.add(ord.Id);
        }

        try {
            List<OrderItem> orderItemList = new List<OrderItem>([SELECT Id, Product2Id, Product2.Quantity_Ordered__c, Quantity, OrderId, Order.Status, Order.ActivatedDate FROM OrderItem WHERE OrderId IN :orderSet]);

            for ( OrderItem oItem : orderItemList){
                Product2 prod = oItem.Product2;
                // Order order = oItem.Order;
                prod.Quantity_Ordered__c += oItem.Quantity;
                if ( oItem.Order.ActivatedDate != null && oItem.Order.Status == 'Activated'){
                    productList.add(prod);
                }
            }
            update productList;
        } catch (Exception e) {
            System.debug('Exception occured:' + e);
        }
    }

    public static void orderDeleteHelper(List<Order> ordersList) {
        List<Product2> productList = new List<Product2>();
        Set<Id> orderSet = new Set<Id>();
        
        for (Order ord : ordersList) {
           orderSet.add(ord.Id);
        }

        try {
            List<OrderItem> orderItemList = new List<OrderItem>([SELECT Id, Product2Id, Product2.Quantity_Ordered__c, Quantity, OrderId, Order.Status, Order.ActivatedDate FROM OrderItem WHERE OrderId IN :orderSet]);

            for ( OrderItem oItem : orderItemList){
                Product2 prod = oItem.Product2;
                // Order order = oItem.Order;
                prod.Quantity_Ordered__c -= oItem.Quantity;
                if ( oItem.Order.ActivatedDate != null && oItem.Order.Status == 'Activated'){
                    productList.add(prod);
                }
            }
            update productList;
        } catch (Exception e) {
            System.debug('Exception occured:' + e);
        }
    }
}