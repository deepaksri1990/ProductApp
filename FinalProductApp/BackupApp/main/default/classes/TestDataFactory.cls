@isTest
public class TestDataFactory {
    public static Product2 createProduct() {
        Product2 prd = new Product2(Name='Test PROD', Product_External_Id__c='8913761232193', isActive=true);
        insert prd;
        return prd;
    }
     public static Product2 createProductWithoutExtId() {
        Product2 prd = new Product2(Name='Test PROD', isActive=true);
        insert prd;
        return prd;
    }

    
    
    public static Product_Backup__c createProductBackup() {
        Product_Backup__c prdBkp = new Product_Backup__c(Name='Test PROD', Product_External_Id__c='8913761232193', Selling_price__c=200);
        insert prdBkp;
        return prdBkp;
    }
    public static Pricebook2 createPriceBook() {
        Pricebook2 pb2 = new Pricebook2();
        pb2.Name='Test Pricebook';
        pb2.IsActive=true;
        insert pb2;
        return pb2;
    }
    
    public static List<Product2> createBulkProducts() {
        Product2 prd;
        List<Product2> prodListToInsert = new List<Product2>(); 
        for(Integer i = 1; i < 200; i++){
            
            prd= new Product2();
            
            if(i < 10){
                prd.Name = 'Test' + i ;
                prd.Product_External_Id__c = 'ExternalIdIs' + i ;
            }else if(i > 9 && i < 100){
                prd.Name = 'Test' + i ;
                prd.Product_External_Id__c = 'ExternalIdI' + i ;
            }else{
                prd.Name = 'Test' + i ;
                prd.Product_External_Id__c = 'ExternalId' + i ;
            }
            
            prd.isActive = true;
            prodListToInsert.add(prd);
        }
        insert prodListToInsert;
        return prodListToInsert;
    }
    public static List<PriceBookEntry> createBulkPriceBookEntries() {
        List<Product2> prodListToInsert = createBulkProducts();
        Pricebook2 pb = createPriceBook();
        List<PriceBookEntry> listToReturn = new List<PriceBookEntry>();
        Pricebook2 testPriceBookRec=[select Id from Pricebook2 where Name ='Test Pricebook'];
        Id stdPriceBookRecId = Test.getStandardPricebookId();
        
        for (Product2 rec : prodListToInsert){
            PriceBookEntry pbeRec = new PriceBookEntry();
            pbeRec.Product2Id = rec.Id;
            pbeRec.Pricebook2Id = stdPriceBookRecId;
            pbeRec.UnitPrice = 2000;
            pbeRec.IsActive = true;
            listToReturn.add(pbeRec);
        }
        insert listToReturn;
        return listToReturn;
        
    }
    
    public static PriceBookEntry createPriceBookEntry(Product2 prd) {
        
        Pricebook2 testPriceBookRec=[select Id from Pricebook2 where Name ='Test Pricebook'];
        Id stdPriceBookRecId = Test.getStandardPricebookId();
        PriceBookEntry pbeRec = new PriceBookEntry();
        pbeRec.Product2Id = prd.Id;
        pbeRec.Pricebook2Id = stdPriceBookRecId;
        pbeRec.UnitPrice = 2000;
        pbeRec.IsActive = true;
        insert pbeRec;
        return pbeRec;
    }
}