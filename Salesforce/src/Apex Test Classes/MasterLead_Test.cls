@isTest()
public class MasterLead_Test {
 
     public static testMethod void testLead(){
         
         //create the custom settings for the contact trigger
         List<TriggerControl__c> settings = new List<TriggerControl__c>();

         TriggerControl__c setting1 = new TriggerControl__c();
         setting1.Name = 'LeadTrigger';     
         settings.add(setting1);
         TriggerControl__c setting2 = new TriggerControl__c();
         setting2.Name = 'LeadTriggerBeforeInsert';     
         settings.add(setting2);
         TriggerControl__c setting3 = new TriggerControl__c();
         setting3.Name = 'LeadTriggerBeforeUpdate';     
         settings.add(setting3);
         TriggerControl__c setting4 = new TriggerControl__c();
         setting4.Name = 'LeadTriggerAfterInsert';     
         settings.add(setting4);
         TriggerControl__c setting5 = new TriggerControl__c();
         setting5.Name = 'LeadTriggerAfterUpdate'; 
         settings.add(setting5); 
         TriggerControl__c setting6 = new TriggerControl__c();
         setting6.Name = 'LeadTriggerAfterDelete';  
         settings.add(setting6); 
         TriggerControl__c setting7 = new TriggerControl__c();
         setting7.Name = 'LeadTriggerAfterUnDelete'; 
         settings.add(setting7);
         
         // enable account, opportunity, contact settings
         TriggerControl__c setting8 = new TriggerControl__c();
         setting8.Name = 'AccountTrigger'; 
         settings.add(setting8);
         TriggerControl__c setting9 = new TriggerControl__c();
         setting9.Name = 'ContactTrigger'; 
         settings.add(setting9);
         TriggerControl__c setting10 = new TriggerControl__c();
         setting10.Name = 'OpportunityTrigger'; 
         settings.add(setting10);
         
         insert settings;
         
         // create the test objects
         CreateTestObjects testObj = new CreateTestObjects();
         List<Account> test_accounts = testObj.CreateAccounts(1, 'test_account');
         insert test_accounts;  
         List<Contact> test_contacts =testObj.CreateContacts(5,'test_contact', test_accounts[0]);
         insert test_contacts;
         List<Lead> test_leads = testObj.CreateLeads(200, 'test_lead', test_accounts[0] );
              
         //insert the leads
         insert test_leads;
       
          test_accounts = [Select id,name,Lead_Count__c,Account_Email_Format__c from Account where id =: test_accounts[0].id];
          test_leads=[Select id, Account__c, Suggested_Email__c from Lead where id in: test_leads];
          test_contacts = [Select id,firstname,Contact_Email_Format__c from Contact where id =: test_contacts];
          test_accounts = [Select id,name,Lead_Count__c,Account_Email_Format__c from Account where id =: test_accounts];
       
           for(Lead l : test_leads){
           System.assertEquals(l.Account__c,test_accounts[0].id);     
           }
     
         // update the leads
         for(Lead l : test_leads){
             l.lastname='test';
         } 
         update test_leads;
         
         test_leads=[Select id, Account__c, Suggested_Email__c from Lead where id in: test_leads];
         test_accounts = [Select id,name,Lead_Count__c from Account where id =: test_accounts[0].id];
           System.assertEquals(200,test_accounts[0].Lead_Count__c);
           for(Lead l : test_leads){
           System.assertEquals(l.Account__c,test_accounts[0].id);
           }
         
         // delete the leads
         delete test_leads[0];  
         test_accounts = [Select id,name,Lead_Count__c from Account where id =: test_accounts[0].id];
         System.assertEquals( 199,test_accounts[0].Lead_Count__c);
 
         // undelete the leads
         undelete test_leads[0];
         test_accounts = [Select id,name,Lead_Count__c from Account where id =: test_accounts[0].id];
          System.assertEquals(200,test_accounts[0].Lead_Count__c);
         for(Lead l : test_leads){
          System.assertEquals(l.Account__c,test_accounts[0].id);
           }
    }

}