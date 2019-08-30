public class Product2Extension {

    // public List<SelectOption> familyOptions {get; set;}
    
    public List<ProductWrapper> productsToInsert {get;set;}

    public Product2Extension(ApexPages.StandardController controller){
        productsToInsert = new List<ProductWrapper>();
        addRows();

    }

    public void AddRows(){
        for ( Integer i=0; i<Constants.DEFAULT_ROWS; i++ ){
            productsToInsert.add(new ProductWrapper(new Product2()));
        }
    }

    public List<ChartHelper.ChartData> GetInventory(){
        return ChartHelper.getInventory();
    }

    public PageReference Save(){
        Savepoint sp = Database.setSavepoint();
        try {
            List<Product2> productsToBeInserted = new List<Product2>();
            List<PricebookEntry> pbeToInsert = new List<PricebookEntry>();
            for (ProductWrapper prodWrap : productsToInsert) {
                System.debug('prodWrap: ' + prodWrap);
                if(prodWrap.productRecord.Name != '' && prodWrap.productRecord.Family != Constants.SELECT_ONE && prodWrap.productRecord.Initial_Inventory__c != null) {
                    System.debug('prodWrap.productRecord: ' + prodWrap.productRecord);
                    productsToBeInserted.add(prodWrap.productRecord);
                    PricebookEntry pbe = prodWrap.priceBookEntryRecord;
                    pbe.isActive = true;
                    pbe.PriceBook2Id = Constants.STANDARD_PRICEBOOK_ID;
                    pbeToInsert.add(pbe);
                } 
                else {
                    apexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'You must fill all the cells'));
                    return null;
                }
            }
            System.debug('productsToBeInserted: ' + productsToBeInserted);
            insert productsToBeInserted;
            for (Integer i = 0; i < pbeToInsert.size(); i++) {
                pbeToInsert[i].Product2Id = productsToBeInserted[i].Id;
            }
            insert pbeToInsert;
            // If successful clear the list and display an informational message
            apexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,productsToInsert.size()+' Inserted'));
            productsToInsert.clear();   
            addRows();  
        } catch (Exception e){
            Database.rollback(sp);
            apexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, Constants.ERROR_MESSAGE));
        }
        return null;
    }

    public List<SelectOption> GetFamilyOptions() {
		return returnFamilyOptionsSelectList();
    }

    public static List<System.SelectOption> returnFamilyOptionsSelectList () {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(Constants.SELECT_ONE, Constants.SELECT_ONE));
        for( PicklistEntry family : Constants.PRODUCT_FAMILY)
            options.add(new SelectOption(family.getValue(), family.getLabel()));
        return options;
    }

    public class ProductWrapper {
        public Product2 productRecord {get; set;}
        public PricebookEntry priceBookEntryRecord {get; set;}
        public ProductWrapper(Product2 prod) {
            this.productRecord = prod;
            this.pricebookEntryRecord = new pricebookEntry(Unitprice=0.0);
        }
    }

}