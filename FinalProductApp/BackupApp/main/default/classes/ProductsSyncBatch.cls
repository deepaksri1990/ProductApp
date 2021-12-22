/**
* @description       : this batch class produces the Product Backup record for every active Product2 records.
                    Considerations:
                    // this batch expects an external Id in Product record and if not present batch creates a one during the run and propagate it to backup.  
                    // An org can have only one standard price book so not adding pricebook filter in the query at line 23 as a part of consideration.
					// Class also implements Schedule and Stateful Interface  
* @author            : Deepak            : 
* @last modified on  : 21-12-2021
* @last modified by  : Deepak Srivastava
**/

public class ProductsSyncBatch implements Database.Batchable<sObject>, Database.Stateful, System.Schedulable {
    
    public Integer processedRecords = 0;
    
    public Database.QueryLocator start(Database.BatchableContext bc){
        // query all active products
        String soqlQuery = 'Select Name, isActive, Product_External_Id__c from Product2 where isActive = true';
        return Database.getQueryLocator(soqlQuery);
    }
    public void execute(Database.BatchableContext bc, List<Product2> scope){
        Map<Id, Product2> prodMap = new Map<Id, Product2>(scope); // to avoid for loop to get record Ids
        Set<Id> recIds = prodMap.KeySet(); 
        List<PriceBookEntry> pbeList = new List<PriceBookEntry>([Select Id, UnitPrice, Product2Id from PriceBookEntry where Product2Id IN: recIds]);
        Map<Id, Double> pbeIdToUnitPriceMap = new Map<Id, Double>(); 
        for(PriceBookEntry pbe1 : pbeList){
            if(!pbeIdToUnitPriceMap.containsKey(pbe1.Product2Id)){
                pbeIdToUnitPriceMap.put(pbe1.Product2Id, pbe1.UnitPrice);    
            }
        }
        List<Product_backup__c> prodBkpList = new List<Product_backup__c>(); 
        Map<Id, String> extIdMap = new Map<Id, String>();
        List<Product2> prodToUpdate = new List<Product2>();
        if(!pbeIdToUnitPriceMap.isEmpty()){
            for(Product2 prodRec : prodMap.values()){
                if(String.isBlank(prodRec.Product_External_Id__c) && !extIdMap.containsKey(prodRec.Id)){
                    prodRec.Product_External_Id__c = String.valueOf(prodRec.Id).right(13);
                    extIdMap.put(prodRec.Id, String.valueOf(prodRec.Id).right(13));
                    prodToUpdate.add(prodRec);
                }
                prodBkpList.add(
                    new Product_backup__c(
                        Name = prodRec.Name,
                        Product_External_Id__c = extIdMap.containsKey(prodRec.Id) ? extIdMap.get(prodRec.Id):prodRec.Product_External_Id__c,
                        Selling_price__c = pbeIdToUnitPriceMap.get(prodRec.Id)
                    )
                );
            }
        }
        if(!prodToUpdate.isEmpty()){
            update prodToUpdate;    
        }
        
        Schema.SObjectField extIdField = Product_backup__c.Fields.Product_External_Id__c;        
        Database.UpsertResult[] srList = Database.upsert(prodBkpList,extIdField,false); 
        for(database.UpsertResult ur : srList){
            if(ur.issuccess()){
                processedRecords++;
            }
        }
    }
    public void finish(Database.BatchableContext bc){  
        EmailUtil.sendEmailToUsers(processedRecords);
    }

/*
 @description:

//String sch1 = '0 41 9 ? * * *'; //to run the job at 9.41
//String sch2 = '0 43 23 ? * * *'; //to run the job second time at 23.43
    
// we can use below commented code to create a schedule run using crone expression 
//System.schedule('First Run',sch1 ,new ProductsSyncBatch());
*/
public void execute(System.SchedulableContext sc){
    Database.executeBatch(new ProductsSyncBatch());
}
}