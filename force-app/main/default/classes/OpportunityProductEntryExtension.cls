public with sharing class OpportunityProductEntryExtension {
        
	public List<PurchaseOrderWrapper> purchaseOrderWrapperList {get; set;}
	// public static List<PurchaseOrderLineItemWrapper> orderItemList {get; set;}
	public Integer orderCount {get; set;}
	public String product2Name {get; set;}
        
        
	// public String unitPriceString {get; set;}
	public Id product2Id {get; set;}
	public List<Product2> productsList {get; set;}
	public Integer rowToRemove {get; set;}
        
        
        
	public opportunityProductEntryExtension(ApexPages.StandardController controller) {
		orderCount = 0;
		purchaseOrderWrapperList = new List<PurchaseOrderWrapper>();
		addRow();
	}
        
    public void addRow() {
        orderCount++;
        purchaseOrderWrapperList.add(new PurchaseOrderWrapper());
    }
            
    public void addProduct() {
        INteger rowNum = Integer.valueOf(ApexPages.currentPage().getParameters().get('rowToRemove'));
        purchaseOrderWrapperList.get(rowNum-1).orderItemList.add(new PurchaseOrderLineItemWrapper());
        System.debug('purchaseOrderWrapperList: '+ purchaseOrderWrapperList);
    }
            
    public void removeRow(){
        rowToRemove = Integer.valueOf(ApexPages.currentPage().getParameters().get('rowToRemove'));
        purchaseOrderWrapperList.remove(rowToRemove);
        // return PurchaseOrderWrapper;
    }
        
        
	/* public class PurchaseOrderWrapper {
	    public PurchaseOrder__c purchaseOrder {get; set;}
	    public List<PurchaseOrderLineItem__c> orderItemList {get; set;}

	    public PurchaseOrderWrapper() {
	        if(purchaseOrder == null) {
	            purchaseOrder = new PurchaseOrder__c();
	            orderItemList = new List<PurchaseOrderLineItem__c>();
	            orderItemList.add(new PurchaseOrderLineItem__c());
	        }
	    }
	   } */
        
	public class PurchaseOrderWrapper {
		public PurchaseOrder__c purchaseOrder {get; set;}
		public List<PurchaseOrderLineItemWrapper> orderItemList {get; set;}
                
		public PurchaseOrderWrapper() {
			if(purchaseOrder == null) {
				purchaseOrder = new PurchaseOrder__c();
				orderItemList = new List<PurchaseOrderLineItemWrapper>();
				orderItemList.add(new PurchaseOrderLineItemWrapper());
			}
		}
	}
        
        
	public class PurchaseOrderLineItemWrapper {
		public PurchaseOrderLineItem__c purchaseOrderLineItem {get; set;}
        public Product2 product {get; set;}
		// public PricebookEntry priceBookEntryRecord {get; set;}
		public PurchaseOrderLineItemWrapper() {
			this.purchaseOrderLineItem = new PurchaseOrderLineItem__c();
            this.product = new Product2();
		}
	}
        
        
	/*
	   public PageReference callLookup(){
	    productsList = [SELECT id, Name FROM Product2];
	    PageReference pr = new PageReference('/apex/ProductLookupPage');
	    pr.setRedirect(false);
	    return pr;
	   }

	   public PageReference goBack(){
	    product2Name = ApexPages.currentPage().getParameters().get('product2Name');
	    product2Id = ApexPages.currentPage().getParameters().get('product2Id');
	    PageReference pr = new PageReference('/apex/OpportunityProduct');
	    pr.setRedirect(false);
	    return pr;
	   }
	 */
}