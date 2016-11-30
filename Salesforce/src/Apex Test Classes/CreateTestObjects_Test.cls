@isTest
public class CreateTestObjects_Test { 
    
     public static testMethod void testCreateTestObjects(){ 
         
        CreateTestObjects testObj = new CreateTestObjects();
         
         List<Account> test_accounts = testObj.CreateAccounts(201, 'test_account');
         List<Contact> test_contacts =testObj.CreateContacts(201,'test_contact', test_accounts[0]);
         List<Opportunity> test_opportunities =testObj.CreateOpportunities(201,'test_opportunity', test_accounts[0],test_contacts[0], 'Complete');
         List<Application__c> test_applications =testObj.CreateApplications(201, 'test_application', test_contacts, test_opportunities);
         List<Agreement__c> test_agreements  = testObj.CreateAgreements(201, 'test_agreement',  test_contacts, test_applications, test_opportunities);
         List<Lead> test_leads = testObj.CreateLeads(201, 'test_lead', test_accounts[0] );
         List<Task> test_tasks  = testObj.CreateTasks( 201, 'test_task', test_contacts[0], test_leads[0]);
         List<Event> test_events  = testObj.CreateEvents(201, 'test_events', test_contacts[0], test_leads[0]);
    
     }
}