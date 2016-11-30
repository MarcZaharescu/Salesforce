@isTest
public class dataListConTest {

    public static testMethod void testdataListCon() {
    
      dataListCon controller = new dataListCon(); 
       
        List<user> userListID= [Select user.id from User where firstName='Marc' AND lastname='Zaharescu'];
        controller.setUserValue1(userListID[0].id);
        controller.setUserValue(userListID[0].id);
      
        
      List<Account>  L1= new List<Account>([SELECT Account.Active_L12M__c, Account.Revenue_To_Date__c,Account.Opportunity_Win_Ratio__c,Account.ownerID,Account.name,owner.firstname, owner.lastname,Account.Opportunities_Created__c , Account.OpportunitiesClosed__c,Account.Average_opportunity_Value__c,Account.Client_Value__c FROM Account
      WHERE Account.OwnerId=:userListID[0].id AND Account.Account_Priority__c='A' AND(Account.Client_Value__c='Other' OR Account.Client_Value__c='Prospect' OR Account.Client_Value__c='High Value' OR Account.Client_Value__c='Loyal'  OR Account.Client_Value__c='One time') Order By Account.Revenue_To_Date__c DESC]); 
      List<Account>  L2= new List<Account>([SELECT Account.Active_L12M__c, Account.Revenue_To_Date__c,Account.Opportunity_Win_Ratio__c,Account.ownerID,Account.name,owner.firstname, owner.lastname,Account.Opportunities_Created__c , Account.OpportunitiesClosed__c,Account.Average_opportunity_Value__c,Account.Client_Value__c FROM Account
      WHERE Account.OwnerId=:userListID[0].id AND Account.Account_Priority__c='B' AND(Account.Client_Value__c='Other' OR Account.Client_Value__c='Prospect' OR Account.Client_Value__c='High Value' OR Account.Client_Value__c='Loyal'  OR Account.Client_Value__c='One time') Order By Account.Revenue_To_Date__c DESC]); 
       
        List<Account> accountsT1=  new List<Account>();
        accountsT1.addALL(L1);
        List<Account> accountsT2=  new List<Account>();
        accountsT1.addALL(L2);
        
  
        System.assertequals(accountsT1, controller.accountsT1);
        System.assertequals(accountsT2, controller.accountsT2);
        
        
        System.assertequals(userListId[0].id , controller.UserValue);
        System.assertequals(null, controller.UserListValue);
        System.assertequals(null, controller.regionOptions);
       
         controller.updateUserValue();
         controller.setUserValue1(userListID[0].id);
         controller.setUserValue(userListID[0].id);
     		
        List<Contact>   contacts1 = [Select id,Contacted_30_days__c,Name,Account.name,Office_Location__c,Phone,Email,Created_opp_count__c,Closed_Opp_Count__c,User_Win_Ratio__c FROM Contact where OwnerId=:  userListID[0].id];    
     	List<Opportunity> openopp1 =  [SELECT  Opportunity.Delivery_Specialist__c , Opportunity.Days_Open__c , Opportunity.Weighted_Probability__c , Opportunity.NextStep,  Opportunity.Opportunity_Commission_Rate__c ,  Opportunity.MBA_Co_Commission__c , Opportunity.Health__c, Opportunity.CreatedDate,Opportunity.ID,Opportunity.name,owner.firstname, owner.lastname,Opportunity.StageName,Opportunity.Gross_Profit__c,Opportunity.CloseDate,Opportunity.Forecast_Judgment__c FROM Opportunity WHERE  Opportunity.ISCLOSED=false  AND Opportunity.OwnerId=: userListID[0].id ];
    	List<Opportunity> closedopp1 =  [SELECT Opportunity.Delivery_Specialist__c , Opportunity.Days_Open__c , Opportunity.Weighted_Probability__c , Opportunity.NextStep,  Opportunity.Opportunity_Commission_Rate__c ,  Opportunity.MBA_Co_Commission__c , Opportunity.Health__c, Opportunity.CreatedDate,Opportunity.ID,Opportunity.name,owner.firstname, owner.lastname,Opportunity.StageName,Opportunity.Gross_Profit__c,Opportunity.CloseDate,Opportunity.Forecast_Judgment__c FROM Opportunity  WHERE Opportunity.ISCLOSED=true   AND  Opportunity.OwnerId=: userListID[0].id];
    
         
         List<Account> accounts1 = new  List<Account>();
         List<Account> accounts2 = new  List<Account>();
        
         System.assertequals(openopp1 , controller.getclosedOpportunities());
         System.assertequals(closedopp1 , controller.getopenOpportunities());
         System.assertequals(accounts1 , controller.accountsT1);
         System.assertequals(accounts2 , controller.accountsT2);
        
           
           List<Contact> contactlist= new List<Contact>([Select id,Contacted_30_days__c,Name,Account.name,Office_Location__c,Phone,Email,Created_opp_count__c,Closed_Opp_Count__c,User_Win_Ratio__c FROM Contact where OwnerId=:userListID[0].id order by Closed_Opp_Count__c DESC]);
           List<Contact> contacts =new List<Contact>();
           contacts.addALL(contactList);
            
           System.assertequals(contacts  , controller.getContact());
            
        
          List<SelectOption> useroptions =new List<SelectOption>();
          List<User> userlist= [Select user.firstname, user.lastname from User where UserRole.Name='UK Sales' OR UserRole.Name='US Sales' OR UserRole.Name='CEO' OR UserRole.Name='Ambassador' OR UserRole.Name='Head of Sales'   OR UserRole.Name='Germany Sales' OR UserRole.Name='Asia Sales' ORDER BY user.lastname ASC];
          userOptions.add(new SelectOption(UserInfo.getUserID(),UserInfo.getfirstname() +' '+ UserInfo.getlastname()));
         
          for(User u :userlist){
                 useroptions.add(new selectoption(u.id, u.firstname +' '+ u.lastname));
            }
          
           System.assertequals(useroptions , controller.getUserOptions());
          

           System.assertequals('Name' , controller.SortExpression);      
           System.assertequals('ASC' ,controller.getSortDirection());
        
        
        
        
    
           controller.getUsername();
           controller.getUserValue1();
        
        
           controller.setLimitSize(1);
           controller.ViewDataAccountsT1();
           controller.ViewDataAccountsT2();
           controller.ViewDataContacts();
           controller.ViewDataOpenOpportunities();
           controller.ViewDataClosedOpportunities();
        
       	   controller.beginningOO();  	 
           controller.nextOO();
         //controller.previousOO();
           controller.getDisablePreviousOO();
           controller.getDisableNextOO();
           controller.setLimitSize(-1);
		   controller.lastOO(); 
        
           controller.setLimitSize(1);
           controller.beginningCO();
           controller.nextCO();
           controller.getDisablePreviousCO();
           controller.getDisableNextCO();
           controller.setLimitSize(-1);
		   controller.lastCO(); 
          // controller.previousCO();
       	   
           controller.setLimitSize(1);
           controller.beginningCC();
           controller.nextCC();
           controller.getDisablePreviousCC();
           controller.getDisableNextCC();
           controller.setLimitSize(-1);
		   controller.lastCC();      
           //controller.lastCC();
           
          controller.setLimitSize(-1000);
          controller.updateUserValue();

    }
}