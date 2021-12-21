@isTest
public class ProductBackupCtrlTest {
    
    static testMethod void testProductSyncBatch() {
        Product2 prd = TestDataFactory.createProduct();
        Pricebook2 pb = TestDataFactory.createPriceBook();
        PriceBookEntry pbeRec = TestDataFactory.createPriceBookEntry(prd);
        Product_Backup__c bkpRec = TestDataFactory.createProductBackup();
        Test.startTest();
        ProductBackupCtrl.ProductWrapper prodWrap = ProductBackupCtrl.getProductDetails(bkpRec.Id);
        
        Test.stopTest();
        System.assertEquals('8913761232193', prodWrap.prodExternalId);
        System.assertEquals(true, [Select isActive from Product2 where Product_External_Id__c =: prodWrap.prodExternalId].isActive);
        
    }
}