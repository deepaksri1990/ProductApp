public class EmailUtil {
    
    public static void sendEmailToUsers(Integer processedRecords){
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {System.label.Emails_ProdBackupBatch}; 
        mail.setToAddresses(toAddresses);
        mail.setSubject(System.label.EmailSubject_ProdBackupBatch); 
        mail.setPlainTextBody('Total' +'  '+ processedRecords +'  '+ 'records processed sucessfully');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}