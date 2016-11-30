@isTest()
public class MasterOpportunity_Test {
 
     public static testMethod void testOpportunity()
    { 
        
         //create the custom settings for the contact trigger
         List<TriggerControl__c> settings = new List<TriggerControl__c>();

         TriggerControl__c setting1 = new TriggerControl__c();
         setting1.Name = 'OpportunityTrigger';     
         settings.add(setting1);
         TriggerControl__c setting2 = new TriggerControl__c();
         setting2.Name = 'OpportunityTriggerBeforeInsert';     
         settings.add(setting2);
         TriggerControl__c setting3 = new TriggerControl__c();
         setting3.Name = 'OpportunityTriggerBeforeUpdate';     
         settings.add(setting3);
         TriggerControl__c setting4 = new TriggerControl__c();
         setting4.Name = 'OpportunityTriggerAfterInsert';     
         settings.add(setting4);
         TriggerControl__c setting5 = new TriggerControl__c();
         setting5.Name = 'OpportunityTriggerAfterUpdate'; 
         settings.add(setting5); 
         TriggerControl__c setting6 = new TriggerControl__c();
         setting6.Name = 'OpportunityTriggerAfterDelete'; 
         settings.add(setting6); 
         TriggerControl__c setting7 = new TriggerControl__c();
         setting7.Name = 'OpportunityTriggerAfterUnDelete'; 
         settings.add(setting7);
 
         insert settings;

       //create test bast for opportuntity line item
       Product2 p1 = new Product2(name='Consultancy Services',CurrencyIsoCode='GBP', isActive=true);
       Product2 p2 = new Product2(name='MBA & Co Commission',CurrencyIsoCode='GBP', isActive=true);
       insert p1;
       insert p2;
        
       System.debug('Soql queries:'+Limits.getLimitQueries() );  
       Account objAccount = new Account(Name='testContactTrigger');
       insert objAccount;
     
       Contact objContact = new Contact(FirstName='firstname',
       lastName='lastname',Email='firstname.lastname1@test.com',
       accountid = objAccount.Id);
       insert objContact;
       
        Date dt = Date.valueOf('2016-01-28');
        List<Task> objTaskBulk = new List<Task>();  
        List<Event> objEventBulk = new List<Event>();
        String textsubject;
        String texttype;
        Boolean Status=True;
	 	for(Integer i=0;i<20;i++) { 
         
         if(math.mod(i,3)==0)
         {textsubject='Call';texttype='Call';}
         if(math.mod(i,3)==1)
         {textsubject='Meeting';texttype='Meeting';}
         if(math.mod(i,3)==2)
         {textsubject='Email';texttype='Email';}
         system.debug('textsubject '+textsubject);
       	  Task objTask = new Task(Subject=textsubject, Send_Notification_Email__c=Status, Email_List__C='marc.zaharescu@mbaco.com',ActivityDate=dt, whoID=objContact.id);
       	  Event objEvent = new Event(Subject=textsubject,type=texttype, Send_Notification_Email__c=Status, Email_List__C='marc.zaharescu@mbaco.com',DurationInMinutes=20,ActivityDateTime=dt, whoID=objContact.id);
		  objTaskBulk.add(objTask);
    	  objEventBulk.add(objEvent);
          Status= False ;  
           
	    }      
      
       insert objTaskBulk;
       insert objEventBulk; 	 	
        
       List<Opportunity> objOpportunityBulk = new List<Opportunity>();
       List<ID>  contactIds = new List<ID>();
       List<ID>  oppIds = new List<ID>();

       Date dt1 = Date.valueOf('2017-01-28');
       Date dt2 = Date.valueOf('2017-05-28');
       for(integer i=0;i<100;i++)
       { 
          if(math.mod(i,3)==0)
           { 
       	 	 Opportunity objOpportunity = new Opportunity(name='Test',closedate=dt1,Start_date__c=dt1, End_date__c=dt2,Client_Contact__c=objContact.id,stagename='Interviewing' ,Project_Stage__c='Platform matching',accountid=objAccount.id); 
             oppIds.add(objOpportunity.id);
         	 objOpportunityBulk.add(objOpportunity);	 
           }
          if(math.mod(i,3)==1)
           { 
       	 	 Opportunity objOpportunity = new Opportunity(name='Test',closedate=dt1,Client_Contact__c=objContact.id,Start_date__c=dt1, End_date__c=dt2,stagename='In Progress' ,Project_Stage__c='1st interview being scheduled',accountid=objAccount.id); 
             oppIds.add(objOpportunity.id);
         	 objOpportunityBulk.add(objOpportunity);	 
           }
           else
           {
       		 Opportunity objOpportunity = new Opportunity(name='Test',closedate=dt1,Client_Contact__c=objContact.id,stagename='Interviewing',Project_Stage__c='Proposals submitted',  accountid=objAccount.id);
             oppIds.add(objOpportunity.id);
         	 objOpportunityBulk.add(objOpportunity);	
           }
       }
        
       insert objOpportunityBulk;
        
       objOpportunityBulk  = [Select ID,name From Opportunity WHERE Id in: oppIds]; 
       for(Opportunity o: objOpportunityBulk){
           o.StageName='In Progress';
       }
       update   objOpportunityBulk;
             
       objOpportunityBulk  = [Select ID,name From Opportunity WHERE Id in: oppIds]; 
       delete   objOpportunityBulk;
          
       undelete objOpportunityBulk;
        
        
   
       
    }
}