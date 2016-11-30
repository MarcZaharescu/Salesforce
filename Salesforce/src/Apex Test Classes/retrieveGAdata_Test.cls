@isTest()
public class retrieveGAdata_Test {
  
    public static final string sDate = 'yesterday'; 
    public static final string eDate = 'today'; 
    
 
    
      public static testmethod  void testretriveGAdata()
      {
          
       retrieveGaData gaTest= new retrieveGAdata();
  
   
          List<List<String>> testSF = new List<List<String>>();
          List<String> test1 = new List<String>();
          List<String> test2 = new List<String>();
          
          //create a test contact
          CreateTestObjects testObj = new CreateTestObjects();
          List<Account> test_accounts = testObj.CreateAccounts(1, 'test_account');
          insert test_accounts;  
          List<Contact>  test_contacts = testObj.CreateContacts(1,'test_contact', test_accounts[0]);
          test_contacts[0].GA_Country__c='Test';
          test_contacts[0].MBACOID__c='1234';
          insert test_contacts;
          
          //create a test lead
          List<Lead>  test_leads = testObj.CreateLeads(1,'test_lead', test_accounts[0]);
          test_leads[0].GA_Country__c='Test';
          test_leads[0].MBACOID__c='12345';
          insert test_leads;
          
          //create a 2 test List<String<String>>
          test1.add('1');test1.add('a');test1.add('a');test1.add('a');test1.add('a');test1.add('a');test1.add('1234');test1.add('123');test1.add('123123');
          test2.add('1');test2.add('a');test2.add('a');test2.add('a');test2.add('a');test2.add('a');test2.add('12345');test2.add('123');test2.add('123123');

          testSF.add(test1);
          testSF.add(test1);
          testSF.add(test2);
          testSF.add(test2);
          
          retrieveGaData.saveDataToSF(testSF); 
        
          String token =retrieveGaData.getToken();
          retrieveGaData.getReportGa(sDate,eDate,token);
          

       
      }
    
    
      public static testMethod void testscheduledGA()
      {
          Test.startTest();
          
          scheduledGoogleAnalytics sga = new  scheduledGoogleAnalytics(); 
          String sch = '20 30 8 10 2 ?'; 
          system.schedule('Test GA check', sch, sga);
          
          Test.stopTest();
         
      }
}