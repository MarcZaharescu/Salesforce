@isTest 

public class MasterAgreement_Test {
 
     public static testMethod void testAgreement(){ 
        
         // create the test objects 
          CreateTestObjects testObj = new CreateTestObjects();
         
         //create the custom settings for the agreement trigger
         List<TriggerControl__c> settings = new List<TriggerControl__c>();
         TriggerControl__c setting1 = new TriggerControl__c();
         setting1.Name = 'AgreementTrigger';     
         settings.add(setting1);
         TriggerControl__c setting2 = new TriggerControl__c();
         setting2.Name = 'AgreementTriggerBeforeInsert';     
         settings.add(setting2);
         TriggerControl__c setting3 = new TriggerControl__c();
         setting3.Name = 'AgreementTriggerBeforeUpdate';     
         settings.add(setting3);
         TriggerControl__c setting4 = new TriggerControl__c();
         setting4.Name = 'AgreementTriggerAfterInsert';     
         settings.add(setting4);
         TriggerControl__c setting5 = new TriggerControl__c();
         setting5.Name = 'AgreementTriggerAfterUpdate';     
         settings.add(setting5); 
     
         insert settings;
       
 
         List<Account> test_accounts = testObj.CreateAccounts(1, 'test_account_test');
         insert test_accounts;  
         List<Contact> test_contacts =testObj.CreateContacts(201,'test_contact_test', test_accounts[0]);
         insert test_contacts;
         List<Opportunity> test_opportunities =testObj.CreateOpportunities(201,'test_opportunity_test', test_accounts[0],test_contacts[0], 'Complete');
         insert test_opportunities;   
         List<Application__c> test_applications =testObj.CreateApplications(201, 'test_application_test', test_contacts, test_opportunities);
         insert test_applications;
      
         //insert the applications 

         List<Agreement__c> test_agreements = testObj.CreateAgreements(201, 'test_agreement_test', test_contacts,test_applications, test_opportunities);
         
         //insert the agreements
         insert test_agreements;
 
         test_agreements = [Select id,name, Application_id__c,Contact_id__c,Project_id__c from Agreement__c where id =: test_agreements  ];
         system.debug(test_applications.size() +'apps:');
         //update  the agreements
         update test_agreements;
         test_agreements = [Select id,name, Application_id__c,Contact_id__c,Project_id__c from Agreement__c where id =: test_agreements  ];
        
         integer i=0;
          for(Agreement__c a : test_agreements){
            System.debug(a.Contact_id__c +' - i ' +i +' - ' + test_contacts[i].id); 
               i++; 
  		   }       
          
            
         }
}