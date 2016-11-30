@isTest()
public class MasterActivity_Test {
 
     public static testMethod void testActivity()
    {  
            
         //create the custom settings for the event,task triggers
         List<TriggerControl__c> settings = new List<TriggerControl__c>();

         //event custom settings
         TriggerControl__c setting1 = new TriggerControl__c();
         setting1.Name = 'EventTrigger';     
         settings.add(setting1);
         TriggerControl__c setting2 = new TriggerControl__c();
         setting2.Name = 'EventTriggerBeforeInsert';     
         settings.add(setting2);
         TriggerControl__c setting3 = new TriggerControl__c();
         setting3.Name = 'EventTriggerBeforeUpdate';     
         settings.add(setting3);
         TriggerControl__c setting4 = new TriggerControl__c();
         setting4.Name = 'EventTriggerAfterInsert';     
         settings.add(setting4);
         TriggerControl__c setting5 = new TriggerControl__c();
         setting5.Name = 'EventTriggerAfterUpdate'; 
         settings.add(setting5); 
         TriggerControl__c setting6 = new TriggerControl__c();
         setting6.Name = 'EventTriggerAfterDelete'; 
         settings.add(setting6); 

         //task custom settings
         TriggerControl__c setting11 = new TriggerControl__c();
         setting11.Name = 'TaskTrigger';     
         settings.add(setting11);
         TriggerControl__c setting21 = new TriggerControl__c();
         setting21.Name = 'TaskTriggerBeforeInsert';     
         settings.add(setting21);
         TriggerControl__c setting31 = new TriggerControl__c();
         setting31.Name = 'TaskTriggerBeforeUpdate';     
         settings.add(setting31);
         TriggerControl__c setting41 = new TriggerControl__c();
         setting41.Name = 'TaskTriggerAfterInsert';     
         settings.add(setting41);
         TriggerControl__c setting51 = new TriggerControl__c();
         setting51.Name = 'TaskTriggerAfterUpdate'; 
         settings.add(setting51); 
         TriggerControl__c setting61 = new TriggerControl__c();
         setting61.Name = 'TaskTriggerAfterDelete'; 
         settings.add(setting61); 
     
         insert settings;
        
        
        
         CreateTestObjects testObj = new CreateTestObjects();
         List<Account> test_accounts = testObj.CreateAccounts(1, 'test_account');
         insert test_accounts;  
         List<Contact> test_contacts =testObj.CreateContacts(1,'test_contact', test_accounts[0]);
         insert test_contacts;
         List<Lead> test_leads = testObj.CreateLeads(1, 'test_lead', test_accounts[0] );
         insert test_leads;
          
         List<Task> test_tasks  = testObj.CreateTasks( 200, 'test_task', test_contacts[0], test_leads[0]);
         List<Event> test_events  = testObj.CreateEvents(200, 'test_events', test_contacts[0], test_leads[0]);
    
         insert test_tasks;
         insert test_events;
       
        
         test_tasks  = [Select ID,Subject,Email_List__C,ActivityDate,CreatedDate,Description,Activity_Type__c,Call_Outcome__c,WhoId From Task WHERE Id in: test_tasks];
         test_events   = [Select ID,Subject,Email_List__C,ActivityDatetime,CreatedDate,Description,Activity_Type__c,Call_Outcome__c,WhoId From Event WHERE Id in:  test_events];
      
        for(integer i =0; i<200;i++)
        {   test_tasks[i].Email_List__c='marc.zaharescu@mbaco.com';
            test_events[i].Email_List__c='marc.zaharescu@mbaco.com';
        }
         update test_tasks;
         update test_events;
               
         test_tasks  = [Select ID,Subject,Email_List__C,ActivityDate,CreatedDate,Description,Activity_Type__c,Call_Outcome__c,WhoId From Task WHERE Id in: test_tasks];
         test_events   = [Select ID,Subject,Email_List__C,ActivityDatetime,CreatedDate,Description,Activity_Type__c,Call_Outcome__c,WhoId From Event WHERE Id in:  test_events];
       
    
         delete test_tasks;
         delete test_events;
        
         undelete test_tasks;
         undelete test_events;
      
         test_tasks  = [Select ID,Subject,Email_List__C,ActivityDate,CreatedDate,Description,Activity_Type__c,Call_Outcome__c,WhoId From Task WHERE Id in: test_tasks];
         test_events   = [Select ID,Subject,Email_List__C,ActivityDatetime,CreatedDate,Description,Activity_Type__c,Call_Outcome__c,WhoId From Event WHERE Id in:  test_events];
       
    
          
    }
}