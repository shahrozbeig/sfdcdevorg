public without sharing class ChartHelper {

    /** 
     * @name getInventory
     * @description Perform a calculation that aggregates active Products that have a positive Quantity_Remaining__c
            And return a list of chartData
            Where the name is the Product Family and the Qty is the sum of the Quantity_Remaining__c
    **/
    @AuraEnabled
    public static List<chartData> getInventory(){
        List<chartData> chartDataList = new List<chartData>();
        
        AggregateResult[] groupedFamilyProduct = [SELECT Family, sum(Quantity_Remaining__c) from Product2 WHERE isActive = true AND Quantity_Remaining__c > 0 GROUP BY Family];
        for (AggregateResult aggResult : groupedFamilyProduct) {
            chartDataList.add(new ChartData((String)aggResult.get('Family'), Integer.valueOf(aggResult.get('expr0'))));
        }
        return chartDataList;
    }

    public class ChartData {
        public String name {get;set;}
        public Decimal val {get;set;}

        public ChartData(String name, Decimal val){
            this.name = name;
            this.val = val;
        }
    }

}