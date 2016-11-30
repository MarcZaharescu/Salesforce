@isTest()
public class MasterAccount_Test {
 
     public static testMethod void testAccount()
    { 
        
         // create test objects
         CreateTestObjects testObj = new CreateTestObjects();
        
         //create the custom settings for the account trigger
         List<TriggerControl__c> settings = new List<TriggerControl__c>();
         TriggerControl__c setting1 = new TriggerControl__c();
         setting1.Name = 'AccountTrigger';     
         settings.add(setting1);
         TriggerControl__c setting2 = new TriggerControl__c();
         setting2.Name = 'AccountTriggerBeforeInsert';     
         settings.add(setting2);
         TriggerControl__c setting3 = new TriggerControl__c();
         setting3.Name = 'AccountTriggerBeforeUpdate';     
         settings.add(setting3);
 
         insert settings;
          
         // insert a batch
         List<Account> test_account = testObj.CreateAccounts(10, 'test_account_test');
         insert test_account;  
        
         // run as a non admin user
         User nonadmin_user = [SELECT Id FROM User WHERE profileId IN (SELECT id FROM Profile WHERE Name != 'System Administrator'  ) AND isActive = TRUE LIMIT 1];

        system.debug('non admin:' + nonadmin_user);
        Test.startTest();
        
        System.runas(nonadmin_user)
        {
 
      
         List<Account> test_accounts = testObj.CreateAccounts(201, 'test_account_test');
         insert test_accounts;  
             
         
         test_accounts=[Select id,name from Account where id in: test_accounts];
         Integer index=0;
         for(Account a :test_accounts){ 
             a.name='TestAccount'+index;
             index++;
         }
         update test_accounts;
        
         test_accounts=[Select id from Account where id in: test_accounts];
         delete test_accounts;
        
         undelete test_accounts;
        
         }
         
         Test.stopTest();
    }
}