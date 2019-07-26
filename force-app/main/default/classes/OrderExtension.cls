/**
 * @name OrderExtension
 * @description This class is provided for you to facilitate the Super Badge
**/
public class OrderExtension {

    public Order orderRecord {get;set;}
    public List<OrderItem> filteredOrderItemList {get;set;}
    public List<OrderItem> orderItemList;
    public String selectedFamily {get;set;}
    public List<chartHelper.chartData> pieData {get;set;}
    public Decimal total {get;set;}

    public Map<Id,OrderItem> orderItemMap;
    ApexPages.StandardSetController standardSetController;

    public OrderExtension(ApexPages.StandardController  standardController){
        orderRecord = (Order)StandardController.getRecord();
        orderItemMap = new Map<id,OrderItem>();
        if ( orderRecord.Id != null ){
            orderRecord = queryOrderRecord(orderRecord.Id);
            pbesFromStandardSetController();
            updatePieChart();
            extractOrderItemsFromPbe();        
            System.debug('Constructor it is');            
        }
        pbesFromStandardSetController();
    }

    void pbesFromStandardSetController(){
        String query = 'SELECT Name, Product2.Family, Product2.Name, Product2Id, UnitPrice, Product2.Quantity_Remaining__c FROM PricebookEntry WHERE IsActive = TRUE';

        if(selectedFamily != null && selectedFamily != Constants.SELECT_ONE) {
            query += ' AND Product2.Family = \'' + selectedFamily + '\'';
        }
        query += ' ORDER BY Name';

        standardSetController = new ApexPages.StandardSetController(Database.getQueryLocator(query));
        standardSetController.setPageSize(Constants.DEFAULT_ROWS);
        System.debug('standardSetController:' + standardSetController);
    }

    void extractOrderItemsFromPbe() {
        filteredOrderItemList = new List<OrderItem>();
        for (SObject obj : standardSetController.getRecords()) {
            PricebookEntry pbe = (PricebookEntry)obj;
            System.debug('pbe: ' + pbe);
            if(orderItemMap.containsKey(pbe.Product2Id)) {
                System.debug('Product: ' + pbe.Product2.Name);
                System.debug('Conatins Key: ' + orderItemMap.get(pbe.Product2Id));
                filteredOrderItemList.add(orderItemMap.get(pbe.Product2Id));
            } 
            /* else{
                OrderItem ot = new OrderItem(
                                PricebookEntryId = pbe.Id,
                                Product2Id = pbe.Product2Id,
                                UnitPrice = pbe.UnitPrice,
                                Quantity = 0,
                                Product2 = pbe.Product2 );
                filteredOrderItemList.add(ot);
                orderItemMap.put(pbe.Product2Id, ot);
            } */
        }
       
    }

    public void updatePieChart() {
        pieData = new List<ChartHelper.ChartData>();
        Decimal totalOrderAmount = 0;
        for (OrderItem ordItem : orderRecord.orderItems) {
            orderItemMap.put(ordItem.Product2Id, ordItem);
            ChartHelper.ChartData pieChartData = new ChartHelper.ChartData(ordItem.Product2.Name, ordItem.Quantity * ordItem.UnitPrice);
            totalOrderAmount += ordItem.Quantity * ordItem.UnitPrice;
            pieData.add(pieChartData);
        }
        total = totalOrderAmount;
    }

    /**
     * @name OnFieldChange
     * @description
    **/
    public void OnFieldChange(){
        updatePieChart();
    }

    /**
     * @name SelectFamily
     * @description
    **/
    public void SelectFamily(){
        pbesFromStandardSetController();
        extractOrderItemsFromPbe();
    }

    /**
     * @name Save
     * @description
    **/
    public PageReference Save(){
        Savepoint sp = Database.setSavepoint();
        try {
            if(orderRecord.Pricebook2Id == null) {
                orderRecord.Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;
            }
            upsert orderRecord;
            
            List<OrderItem> orderItemsToUpsert = new List<OrderItem>();
            List<OrderItem> orderItemsToDelete = new List<OrderItem>();
            for (OrderItem oItem : filteredOrderItemList) {
                if(oItem.Quantity > 0) {
                    orderItemsToUpsert.add(oItem);
                } else {
                    orderItemsToDelete.add(oItem);
                }
            }
            upsert orderItemsToUpsert;
            delete orderItemsToDelete;
            return standardSetController.save();
        } catch (Exception ex) {
            Database.rollback(sp);
            apexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,Constants.ERROR_MESSAGE));
            return null;
        }
    }


    /**
     * @name First
     * @description
    **/
    public void First(){
        standardSetController.first();
        extractOrderItemsFromPbe();
    }


    /**
     * @name Next
     * @description
    **/
    public void Next(){
        standardSetController.next();
        extractOrderItemsFromPbe();
    }


    /**
     * @name Previous
     * @description
    **/
    public void Previous(){
        standardSetController.previous();
        extractOrderItemsFromPbe();
    }

    /**
     * @name Last
     * @description
    **/
    public void Last(){
        standardSetController.last();
        extractOrderItemsFromPbe();
    }

    /**
     * @name GetHasPrevious
     * @description
    **/
    public Boolean GetHasPrevious(){
        return GetPageNumber()>1;
        // return standardSetController.getHasPrevious();
    }

    /**
     * @name GetHasNext
     * @description
    **/
    public Boolean GetHasNext(){
        return GetPageNumber()>0 && GetPageNumber()<GetTotalPages();
        // return standardSetController.getHasNext();
    }

    /**
     * @name GetTotalPages
     * @description
    **/
    public Integer GetTotalPages(){
        return (Integer)Math.ceil(orderRecord.OrderItems.size() / (Decimal)Constants.DEFAULT_ROWS);
        // return (Integer)Math.ceil(standardSetController.getResultSize() / (Decimal)Constants.DEFAULT_ROWS);
    }

    /**
     * @name GetPageNumber
     * @description
    **/
    public Integer GetPageNumber(){
        return standardSetController.getPageNumber();
    }

    /**
     * @name GetFamilyOptions
     * @description
    **/
    public List<SelectOption> GetFamilyOptions(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(Constants.SELECT_ONE, Constants.SELECT_ONE));
        for(Schema.Picklistentry ple : Constants.PRODUCT_FAMILY) {
            options.add(new SelectOption(ple.getValue(), ple.getLabel()));
        }
        return options;
    }

    /**
     * @name QueryOrderRecord
     * @description
    **/
    public static Order QueryOrderRecord(Id orderId){
        return [
            SELECT Id, AccountId, EffectiveDate, Name, Status, Pricebook2Id, TotalAmount, 
                (
                    SELECT Id, OrderId, Quantity, UnitPrice, PricebookEntryId, Product2Id,
                         Product2.Name, Product2.Family, Product2.Quantity_Remaining__c
                    FROM OrderItems
                )
            FROM Order
            WHERE Id = :orderId
        ];
    }

}

