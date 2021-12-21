/**
* @description       : Test class for ProductsSyncBatch class.
* @author            : Deepak            : 
* @last modified on  : 21-12-2021
* @last modified by  : Deepak Srivastava
**/

@isTest
public class ProductSyncBatchTest {
    
    static testMethod void testProductSyncBatch() {
        Product2 prd = TestDataFactory.createProduct();
        Pricebook2 pb = TestDataFactory.createPriceBook();
        PriceBookEntry pbeRec = TestDataFactory.createPriceBookEntry(prd);
        Test.startTest();
        Database.executeBatch(new ProductsSyncBatch());
        Test.stopTest();
        System.assertNotEquals(0, [Select count() from Product_backup__c]);
        Product2 rec  = [Select Product_External_Id__c from Product2 where name = 'Test PROD' limit 1];
        System.assert([Select count() from Product_backup__c] != 0);
        System.assertEquals(rec.Product_External_Id__c, [Select Product_External_Id__c from Product_backup__c where Product_External_Id__c = : rec.Product_External_Id__c].Product_External_Id__c);
    }	
    
    // this test method checks the batch with bulk data. 
    static testMethod void testBulkProductSyncBatch() {
        List<PriceBookEntry> pbeList = TestDataFactory.createBulkPriceBookEntries();
        Test.startTest();
        Database.executeBatch(new ProductsSyncBatch());
        Test.stopTest();
        Integer prodCount = [select count() from Product2 where isActive = true];
        System.assertEquals(prodCount, [Select count() from Product_backup__c ]);
    }
    
    static testMethod void testProductSyncWithoutExternalId() {
        
        Product2 prd = TestDataFactory.createProductWithoutExtId();
        Pricebook2 pb = TestDataFactory.createPriceBook();
        PriceBookEntry pbeRec = TestDataFactory.createPriceBookEntry(prd);
        Test.startTest();
        Database.executeBatch(new ProductsSyncBatch());
        Test.stopTest();
        Integer prodCount = [select count() from Product2 where isActive = true];
        Product2 rec = [select Id, Product_External_Id__c from Product2 where Id =: prd.Id];
        System.assertEquals(prodCount, [Select count() from Product_backup__c ]);
        System.assert(String.isNotBlank(rec.Product_External_Id__c));
    }
    
    
}