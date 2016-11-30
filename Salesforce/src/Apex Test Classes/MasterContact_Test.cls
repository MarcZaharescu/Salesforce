@isTest()
public class MasterContact_Test {
 
     public static testMethod void testContact(){ 
         
        //create the custom settings for the contact trigger
         List<TriggerControl__c> settings = new List<TriggerControl__c>();

         TriggerControl__c setting1 = new TriggerControl__c();
         setting1.Name = 'ContactTrigger';     
         settings.add(setting1);
         TriggerControl__c setting2 = new TriggerControl__c();
         setting2.Name = 'ContactTriggerBeforeInsert';     
         settings.add(setting2);
         TriggerControl__c setting3 = new TriggerControl__c();
         setting3.Name = 'ContactTriggerBeforeUpdate';     
         settings.add(setting3);
         TriggerControl__c setting4 = new TriggerControl__c();
         setting4.Name = 'ContactTriggerAfterInsert';     
         settings.add(setting4);
         TriggerControl__c setting5 = new TriggerControl__c();
         setting5.Name = 'ContactTriggerAfterUpdate'; 
         settings.add(setting5); 
         TriggerControl__c setting6 = new TriggerControl__c();
         setting6.Name = 'ContactTriggerAfterDelete'; 
         settings.add(setting6); 
         TriggerControl__c setting7 = new TriggerControl__c();
         setting7.Name = 'ContactTriggerAfterUnDelete'; 
         settings.add(setting7);
 
         insert settings;
        
         CreateTestObjects testObj = new CreateTestObjects();
         List<Account> test_accounts = testObj.CreateAccounts(1, 'test_account');
         insert test_accounts;  
         List<Contact> test_contacts =testObj.CreateContacts(200,'test_contact', test_accounts[0]);
         insert test_contacts;
        
         test_accounts = [Select id,name,Contact_Count__c,Account_Email_Format__c from Account where id =: test_accounts[0].id];      
         System.assertEquals(200, test_accounts[0].Contact_Count__c);
     
         // update the contacts
         for(Contact c : test_contacts){
             c.lastname='Test';
             c.function__c='Test';
             c.seniority__c='Test';
         } 
         update test_contacts;         
     
         test_accounts = [Select id,name,Contact_Count__c from Account where id =: test_accounts[0].id];
         System.assertEquals(200, test_accounts[0].Contact_Count__c);
         
         // delete the contacts
         delete test_contacts[0];  
         test_accounts = [Select id,name,Contact_Count__c from Account where id =: test_accounts[0].id];
   		 System.assertEquals(199, test_accounts[0].Contact_Count__c);
 
         // undelete the contacts
         undelete test_contacts[0];
         test_accounts = [Select id,name,Contact_Count__c from Account where id =: test_accounts[0].id];
         System.assertEquals(200, test_accounts[0].Contact_Count__c);
     }
}