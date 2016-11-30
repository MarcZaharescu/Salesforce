public class ClassEventHandler {
    
    
    Map<ID,Event> newEvents;  
    Map<ID,Event> oldEvents;  
    
    public ClassEventHandler(Map<ID,Event> newTriggerEvents,Map<ID,Event> oldTriggerEvents){
        newEvents=newTriggerEvents;
        oldEvents=oldTriggerEvents;
    }
    
    
    
    
 	 // 1...................Add Client Status Method
 	 // 
 	 //  
 	 //   
 	 //    
 	 //     
 	 //      
 	 //        

    public void addClientStatus()
    {
         
    List<Contact> contacts = new List<Contact>();
    List<Lead> leads = new List<Lead>();
    List<ID> eventsToUpdateC = new List<ID>();
    List<ID> eventsToUpdateL = new List<ID>();
    
  
    { 
         for( Event e: newEvents.values())
    		{
               if(e.WhoId!=NULL)
               {
                   if(e.WhoId.getSObjectType()==Schema.Contact.sObjectType)
               		 { 
              		     eventsToUpdateC.add(e.whoID);
               		 }
                  
                    if(e.WhoId.getSObjectType()==Schema.Lead.sObjectType)
               		 {              		   
                         eventsToUpdateL.add(e.whoID);
               		 }
               }
                
            }
    }
    	
     contacts=[Select Account.Client_Status__c   from Contact where contact.id in: eventsToUpdateC];
     leads =[Select Account__r.Client_Status__c  from Lead where lead.id=: eventsToUpdateL];
     Map <id,String> eheMap = new Map<id,String>();
    
    
     for(Contact c: contacts) {
       	 eheMap.put(c.id,c.Account.Client_Status__c);
     } 
      for(Lead l: leads){
       	 eheMap.put(l.id,l.Account__r.Client_Status__c);
     }
    
 
     { 
      for( Event e: newEvents.values()) {
          String s = eheMap.get(e.whoId);
          e.Client_Status__c=s;
      }
    }
    
  }
    
    
     // 2............ Lead Activity Count Method
     // 
 	 //  
 	 //   
 	 //    
 	 //     
 	 //      
 	 //
    
    public void LeadActivityCount()
    {
        
	Set<ID> LeadIds = new Set<ID>();
	String leadPrefix = Lead.SObjectType.getDescribe().getKeyPrefix();
        
   if(newEvents!=null)
     for (Event e :  newEvents.values()) {
    	 if (e.WhoId!= null && string.valueof(e.WhoId).startsWith(leadPrefix) ) {
			if(!LeadIds.contains(e.WhoId)){
				//adding unique lead ids since ehere can be many events with single lead
				LeadIds.add(e.WhoId);
			}
     	   }	
  	     }
       
    if(oldEvents!=null)
     for (Event e2 : oldEvents.values()) {
       if (e2.WhoId!= null && string.valueof(e2.WhoId).startsWith(leadPrefix) )
         {
			if(!LeadIds.contains(e2.WhoId)){
			LeadIds.add(e2.WhoId);
			}
		   }
         }
     

    if (LeadIds.size() > 0){
		List<Lead> leadsWithEvents = [select id,Activity_Count__c,(select id from Events) from Lead where Id IN : Leadids];
		List<Lead> leadsUpdatable = new List<Lead>();

   		 for(Lead L : leadsWithEvents){
			L.Activity_Count__c = L.Events.size();
		 	leadsUpdatable.add(L);
		  }

			if(leadsUpdatable.size()>0){
			update leadsUpdatable;
			}
   	     }
    
    }
    
    
    
     // 3............Last Activity Date on Contact
     // 	 
 	 //  
     //   
 	 //    
  	 //     
 	 //      
 	 //
   
    public void LastContactActivityDate(){
        
     Set<String> cwhatIDs = new Set<String>();
      Set<String> lwhatIDs = new Set<String>();
      Map<String,Event> eventmap= new Map<String,Event>();
     
      for (Event e : newEvents.values()) {
          
      if(e.whoId!=null){ 
          
        if(e.WhoId.getSObjectType()==Schema.Contact.sObjectType)
     	 cwhatIDs.add(e.whoID);
        
        if(e.WhoId.getSObjectType()==Schema.Lead.sObjectType) 
          lwhatIDs.add(e.whoID);
          
         eventmap.put(e.whoId,e);
       }
  	  }
    
     List<Contact> contacts = [SELECT Id, Last_Activity_Date__c FROM Contact where ID=:cwhatIDs ];
     List<Lead> leads = [SELECT Id, Last_Activity_Date__c FROM Lead where ID=:lwhatIDs ];
 
      for (Contact c: contacts) {   
           if (eventmap.containsKey(c.Id)) {
            c.Last_Activity_Date__c  = eventMap.get(c.Id).ActivityDate;
           }
        }  
        
       for (Lead l: leads) {   
           if (eventmap.containsKey(l.Id)) {
            l.Last_Activity_Date__c  = eventMap.get(l.Id).ActivityDate;
           }
        }  
    update contacts;
    update leads;   }     
    
    
    //.......................Update Lead Status If Contacted
    //
    //
    //
    //
    //
    //
    //
    //
    //
   
    
    public void UpdateLeadStatusIfContacted(){
   	  /* not being used anymore
        Set<String> whatIDs = new Set<String>();
 
    	for (Event e : newEvents.values()) {
     		 whatIDs.add(e.whoID);
        }
 
        List<Lead> leads = [SELECT Id, Status FROM Lead where ID=:whatIDs And (Status='Open - Not Contacted' OR Status='Marketing suspect') ];
    	for (Lead l: leads) {
       		 l.Status = 'Working - Contacted';
  		}
  		update leads;
	 */
    } 
    
    
    //.......................Send A Notification Email
    //
    //
    //
    //
    //
    //
    //
    //
    //
    public void sendNotificationEmail()
    {
     
        for(Event e: newEvents.values())
     	{
         	if(e.Send_Notification_Email__c==TRUE && e.Email_List__C!=null)
         	{
           
      	     if(e.Email_List__c.length()>0)
             {
     		 String usernames=e.Email_List__c;
	 		 List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
     		 Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
             
             String[] emails =usernames.split(';');
           
     		 List<String> sendTo = new List<String>();
             for(Integer i =0; i<emails.size();i++){
     			 sendTo.add(emails[i]);
             }
     
             
     		 List<User> currentUser = [SELECT Id, Name,Email FROM User WHERE Id=:userinfo.getUserId() LIMIT 1];
			 String myName = currentUser[0].Name; 
             
             //add the current user
             sendTo.add(currentUser[0].Email);
                 
             mail.setToAddresses(sendTo);
     		 mail.setSenderDisplayName(myName);
              
             List<Contact> currentContact =[Select id,accountid,firstname,lastname from Contact where id=:e.WhoId  ];
             List<Lead> currentLead =[Select id,account__c,firstname,lastname from Lead where id=:e.WhoId  ];  
                 
                  String myContact='[field missing]';
                  String myAccount='[field missing]';
                  String myAccountPotential='[field missing]';
                  String myClientStatus='[field missing]';
                 
              if(e.WhoId.getSObjectType()==Schema.Contact.sObjectType)
              {
              	 if(currentContact.size()>0)
              		 {
              		     myContact= currentContact[0].firstname+ ' '+currentContact[0].lastname;
              			 List<Account> currentAccount =[Select id,name,Account_Priority__c,Client_Status__c from Account where id=:currentContact[0].accountid ];
              		     myAccount= currentAccount[0].name;
               			 myAccountPotential=currentAccount[0].Account_Priority__c;
               			 myClientStatus=currentAccount[0].Client_Status__c;
              		 }
              }
                 
             else
                 
              if(e.WhoId.getSObjectType()==Schema.Lead.sObjectType)
              {
                if(currentLead.size()>0)
                 {
                     myContact= currentLead[0].firstname+ ' '+currentLead[0].lastname;
                   
             		 List<Account> currentAccount =[Select id,name,Account_Priority__c,Client_Status__c from Account where id=:currentLead[0].account__c ];
             		 myAccount= currentAccount[0].name;
              	     myAccountPotential=currentAccount[0].Account_Priority__c;
              		 myClientStatus=currentAccount[0].Client_Status__c;
                 }
              }
       
             Map <Integer, String> months = new Map <Integer, String> {1=>'January', 2=>'Febuary', 3=>'March', 4=>'April', 5=>'May', 6=>'June', 7=>'July', 8=>'August', 9=>'September', 10=>'October', 11=>'November', 12=>'December'};
 		     list<String> lstSplitDate = string.valueOfGmt(e.CreatedDate).split('-');
             String[] daynumber=lstSplitDate[2].split(' ');
   		     String month = months.get(Integer.valueOf(lstSplitDate[1]));
	         Integer day = Integer.valueOf(Integer.valueOf(daynumber[0]));
  		     Integer year = Integer.valueOf(Integer.valueOf(lstSplitDate[0]));
             String myCreatedDate=day +' '+month+' '+year;   
		
     		 mail.setSubject(e.Activity_Type__c+': ' +myName +' (' +myContact+ ' at ' + myAccount +')');
     		 String body= '<html><body style="font-family:Calibri,Candara,Segoe,Segoe UI,Optima, eimes, serif; font-size: 12pt;">';
                
             body += '<p style="font-family:Calibri,Candara,Segoe,Segoe UI,Optima, eimes, serif;">';
             body += e.Activity_Type__C+' activity logged by ' +myName+' on '+myCreatedDate+' with '+myContact+'</br>';
             body +='<b>'+myAccountPotential+' '+myClientStatus+' '+myAccount+'</b></br>';
             body +='<a href="https://emea.salesforce.com/'+e.id+'" style="text-decoration:none;">https://emea.salesforce.com/'+e.id+'</a></br>'+'</br>';
             body += 'Subject: '+e.Subject+'</br>'; 
             body += 'Outcome: '+e.Call_Outcome__c+'</br>'+'</br></p>'; 
             body += '<div style="max-width: 96%"><p>Output and Action Points: '+e.Description+'</p><br/>'+'<br/>'+ '<br/></div></body></html>';                
    		 mail.setHtmlBody(body);
     		 mails.add(mail);
			 Messaging.sendEmail(mails);
                 
             }
          }
         
      }
    }
 
    
    
    

}