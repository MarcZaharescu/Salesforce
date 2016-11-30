@isTest()

public class MasterApplication_Test {
  
     public static testMethod void testApplication(){ 
         
         // create test objects
         CreateTestObjects testObj = new CreateTestObjects();
         
          //create the custom settings for the agreement trigger
         List<TriggerControl__c> settings = new List<TriggerControl__c>();
         TriggerControl__c setting1 = new TriggerControl__c();
         setting1.Name = 'ApplicationTrigger';     
         settings.add(setting1);
         TriggerControl__c setting2 = new TriggerControl__c();
         setting2.Name = 'ApplicationTriggerBeforeInsert';     
         settings.add(setting2);
         TriggerControl__c setting3 = new TriggerControl__c();
         setting3.Name = 'ApplicationTriggerBeforeUpdate';     
         settings.add(setting3);
         TriggerControl__c setting4 = new TriggerControl__c();
         setting4.Name = 'ApplicationTriggerAfterInsert';     
         settings.add(setting4);
         TriggerControl__c setting5 = new TriggerControl__c();
         setting5.Name = 'ApplicationTriggerAfterUpdate';     
         settings.add(setting5); 
     
         insert settings;
          
         Test.startTest();
         
         List<Account> test_accounts = testObj.CreateAccounts(1, 'test_account_test');
         insert test_accounts;  
         List<Contact> test_contacts =testObj.CreateContacts(201,'test_contact_test', test_accounts[0]);
         insert test_contacts;
         List<Opportunity> test_opportunities =testObj.CreateOpportunities(201,'test_opportunity_test', test_accounts[0],test_contacts[0], 'Complete');
         insert test_opportunities;
         List<Application__c> test_applications =testObj.CreateApplications(201, 'test_application_test', test_contacts, test_opportunities);
        
         //insert the applications
         insert test_applications;
         test_applications = [Select id,name, Contact_id__c,Opportunity_id__c from Application__c where id =: test_applications ];
          
         //update the applications
         update test_applications;
         test_applications = [Select id,name, Contact_id__c,Opportunity_id__c from Application__c where id =: test_applications ];
         
             
           integer i=0;
           for(Application__c a : test_applications){
               System.debug(a.Contact_id__c +' - i ' +i +' - ' + test_contacts[i].id); 
              // System.assertEquals(a.Contact_id__c,test_contacts[i].id);
             //System.assertEquals(a.Opportunity_id__c,test_opportunities[i].id);
               i++;
  		  }       
         
            Test.stopTest();
         }
}