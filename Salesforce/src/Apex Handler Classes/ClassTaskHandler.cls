public class ClassTaskHandler {

    Map<ID,Task> newTasks;  
    Map<ID,Task> oldTasks;  
    
    public ClassTaskHandler(Map<ID,Task> newTriggerTasks,Map<ID,Task> oldTriggerTasks){
        newTasks=newTriggerTasks;
        oldTasks=oldTriggerTasks;
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
    List<ID> tasksToUpdateC = new List<ID>();
    List<ID> tasksToUpdateL = new List<ID>();
    
  
    { 
         for( Task t: newTasks.values())
    		{
               if(t.WhoId!=NULL)
               {
                   if(t.WhoId.getSObjectType()==Schema.Contact.sObjectType)
               		 { 
              		     tasksToUpdateC.add(t.whoID);
               		 }
                  
                    if(t.WhoId.getSObjectType()==Schema.Lead.sObjectType)
               		 {              		   
                         tasksToUpdateL.add(t.whoID);
               		 }
               }
                
            }
    }
    	
     contacts=[Select Account.Client_Status__c   from Contact where contact.id in: tasksToUpdateC];
     leads =[Select Account__r.Client_Status__c  from Lead where lead.id=: tasksToUpdateL];
     Map <id,String> theMap = new Map<id,String>();
    
    
     for(Contact c: contacts) {
       	 theMap.put(c.id,c.Account.Client_Status__c);
     } 
      for(Lead l: leads){
       	 theMap.put(l.id,l.Account__r.Client_Status__c);
     }
    
 
     { 
      for( Task t: newTasks.values()) {
          String s = theMap.get(t.whoId);
          t.Client_Status__c=s;
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
        
 if(newTasks!=null)
    for (Task t :  newTasks.values()) {
    	 if (t.WhoId!= null && string.valueof(t.WhoId).startsWith(leadPrefix) ) {
			if(!LeadIds.contains(t.WhoId)){
				//adding unique lead ids since there can be many tasks with single lead
				LeadIds.add(t.WhoId);
			}
     	   }	
  	     }
       
 if(oldTasks!=null)
     for (Task t2 : oldTasks.values()) {
     if (t2.WhoId!= null && string.valueof(t2.WhoId).startsWith(leadPrefix) )
         {
			if(!LeadIds.contains(t2.WhoId)){
			LeadIds.add(t2.WhoId);
			}
		   }
         }
     

    if (LeadIds.size() > 0){
		List<Lead> leadsWithTasks = [select id,Activity_Count__c,(select id from Tasks) from Lead where Id IN : Leadids];
		List<Lead> leadsUpdatable = new List<Lead>();

   		 for(Lead L : leadsWithTasks){
			L.Activity_Count__c = L.Tasks.size();
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
      Map<String,Task> taskmap= new Map<String,Task>();
     
      for (Task t : newTasks.values()) {
            
        if(t.whoId!=null){ 
        
         if(t.WhoId.getSObjectType()==Schema.Contact.sObjectType)
     	 cwhatIDs.add(t.whoID);
        
          if(t.WhoId.getSObjectType()==Schema.Lead.sObjectType) 
          lwhatIDs.add(t.whoID);
          
         taskmap.put(t.whoId,t);      
        }
  	  }
    
     List<Contact> contacts = [SELECT Id, Last_Activity_Date__c FROM Contact where ID=:cwhatIDs ];
     List<Lead> leads = [SELECT Id, Last_Activity_Date__c FROM Lead where ID=:lwhatIDs ];
 
      for (Contact c: contacts) {   
           if (taskmap.containsKey(c.Id)) {
            c.Last_Activity_Date__c  = taskMap.get(c.Id).ActivityDate;
           }
        }  
        
       for (Lead l: leads) {   
           if (taskmap.containsKey(l.Id)) {
            l.Last_Activity_Date__c  = taskMap.get(l.Id).ActivityDate;
           }
        }  
    update contacts;
    update leads;
   }     
    
    
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
 
    	for (Task t : newTasks.values()) {
     		 whatIDs.add(t.whoID);
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
     
        for(Task t: newTasks.values())
     	{
         	if(t.Send_Notification_Email__c==TRUE && t.Email_List__C!=null)
         	{
           
      	     if(t.Email_List__c.length()>0)
             {
     		 String usernames=t.Email_List__c;
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
              
             List<Contact> currentContact =[Select id,accountid,firstname,lastname from Contact where id=:t.WhoId  ];
             List<Lead> currentLead =[Select id,account__c,firstname,lastname from Lead where id=:t.WhoId  ];  
                 
                  String myContact='[field missing]';
                  String myAccount='[field missing]';
                  String myAccountPotential='[field missing]';
                  String myClientStatus='[field missing]';
                 
              if(t.WhoId.getSObjectType()==Schema.Contact.sObjectType)
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
                 
              if(t.WhoId.getSObjectType()==Schema.Lead.sObjectType)
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
 		     list<String> lstSplitDate = string.valueOfGmt(t.CreatedDate).split('-');
             String[] daynumber=lstSplitDate[2].split(' ');
   		     String month = months.get(Integer.valueOf(lstSplitDate[1]));
	         Integer day = Integer.valueOf(Integer.valueOf(daynumber[0]));
  		     Integer year = Integer.valueOf(Integer.valueOf(lstSplitDate[0]));
             String myCreatedDate=day +' '+month+' '+year;   
		
     		 mail.setSubject(t.Activity_Type__c+': ' +myName +' (' +myContact+ ' at ' + myAccount +')');
     		 String body= '<html><body style="font-family:Calibri,Candara,Segoe,Segoe UI,Optima, times, serif; font-size: 12pt;">';
                
             body += '<p style="font-family:Calibri,Candara,Segoe,Segoe UI,Optima, times, serif;">';
             body += t.Activity_Type__C+' activity logged by ' +myName+' on '+myCreatedDate+' with '+myContact+'</br>';
             body +='<b>'+myAccountPotential+' '+myClientStatus+' '+myAccount+'</b></br>';
             body +='<a href="https://emea.salesforce.com/'+t.id+'" style="text-decoration:none;">https://emea.salesforce.com/'+t.id+'</a></br>'+'</br>';
             body += 'Subject: '+t.Subject+'</br>'; 
             body += 'Outcome: '+t.Call_Outcome__c+'</br>'+'</br></p>'; 
             body += '<div style="max-width: 96%"><p>Output and Action Points: '+t.Description+'</p><br/>'+'<br/>'+ '<br/></div></body></html>';                
    		 mail.setHtmlBody(body);
     		 mails.add(mail);
			 Messaging.sendEmail(mails);
                 
             }
          }
         
      }
    }
 
    
    
    
    
}