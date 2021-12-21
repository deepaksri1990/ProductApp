/**
* @description       : .this is a controller class for backupProductCmp LWC component. It returns the wrapper which 
						includes Product backup record and related product details to lwc component. 
						Considerations:
						
* @author            : Deepak            
* @last modified on  : 21-12-2021
* @last modified by  : Deepak Srivastava
**/
public class ProductBackupCtrl {
    
    @AuraEnabled(cacheable=true)
    public static ProductWrapper getProductDetails(String recordId) {
        
        Product_Backup__c prodBkp;
        if(String.isNotBlank(recordId)){
        	prodBkp = [select Id, Product_External_Id__c, Selling_Price__c, Name from Product_Backup__c where Id =:recordId];
        }
        Product2 prodRec;
        if(String.isNotBlank(prodBkp.Product_External_Id__c)){
           prodRec = [select Id, Name, isActive, createdDate from  Product2 where Product_External_Id__c =:prodBkp.Product_External_Id__c]; 
        }
        //prodRec will always return data bcoz there will not be a PROD backup record without PROD record. 
        
        ProductWrapper wc = new ProductWrapper();
        wc.prodName = prodBkp.Name;
        wc.prodExternalId = prodBkp.Product_External_Id__c;
        wc.prodPrice = prodBkp.Selling_Price__c;
        wc.isActive = prodRec.IsActive;
        wc.prodCreatedDate = prodRec.CreatedDate;
        return wc;
    }
    
    public class ProductWrapper{
        @AuraEnabled public String prodName{get;set;}
        @AuraEnabled public String prodExternalId{get;set;}
        @AuraEnabled public Double prodPrice{get;set;}
        @AuraEnabled public Boolean isActive{get;set;}
        @AuraEnabled public Datetime prodCreatedDate{get;set;}
    }
}