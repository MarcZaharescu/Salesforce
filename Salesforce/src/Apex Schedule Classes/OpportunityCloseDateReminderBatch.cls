// batch class to set the lead status to Return by Marketing
// is activated by the time based trigger, evoked from the Return to Marketing workflow on the Lead object

    public with sharing class OpportunityCloseDateReminderBatch  
    implements Database.Batchable<SObject>, Schedulable
   {
    // for the test method
    public static String CRON_EXP = '0 0 0 3 9 ? 2022';
    
    @TestVisible static DateTime threshold =  Datetime.now().addDays(1);
    @TestVisible static Date dtreshold =  date.newinstance(threshold.year(), threshold.month(), threshold.day());
      
     public String query = 'SELECT Id,ownerid,closedate,name FROM Opportunity WHERE isClosed =false and closedate =: dtreshold  and (stagename != \'Pending Payment\' OR stagename != \'Complete\'  OR stagename !=    \'Rejected\'   OR stagename !=    \'Cancelled\'  )';
    
    public Database.QueryLocator start(Database.BatchableContext context )
    { system.debug('BatchActivityDate start');
        return Database.getQueryLocator( query  );
    }
    public void execute(Database.BatchableContext context, List<Opportunity> scope)
    {     system.debug('BatchActivityDate - execute 2');
        
         List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
     		
          Map<id, string> userMap = new Map<id,String>();
          Map<id, string> opportunityMap = new Map<id,String>();
        
          List<User> users = [SELECT Id, Name,Email FROM User WHERE Id=:userinfo.getUserId() and isActive=true ];
          for(User u : users ){
              if(u.email!=null && u.name!=null)
            usermap.put(u.id, u.email+'#'+u.name);
          }
        
           for (Opportunity record : scope){
             opportunityMap.put(record.id,usermap.get(record.ownerid));
           }
             
        for (Opportunity record : scope)  
        {
            if(opportunityMap.get(record.id)!=null)
            {   
                 if(opportunityMap.get(record.id).contains('#'))
                 { 
                  Messaging.SingleEmailMessage mail =  formEmail(opportunityMap.get(record.id),record);
                  mails.add(mail);
                 }
            }
           
            }
            
             Messaging.sendEmail(mails);
        }
        
     
   

     public  Messaging.SingleEmailMessage formEmail(String currentuser, Opportunity record)
    {  
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        // send an email with the users
             String[] userData = currentuser.split('#');
        
            if(userData.size()>1)
            { 
            String userName = userData[1];
            String userEmail = userData[0];
           
     		 List<String> sendTo = new List<String>();
		 
             sendTo.add(userEmail);   
             mail.setToAddresses(sendTo);
     		 mail.setSenderDisplayName(userName);
     		 mail.setSubject('Review Close Date');
     		 String body= '<html><body style="font-family:Calibri,Candara,Segoe,Segoe UI,Optima, times, serif; font-size: 12pt;">';
             body += 'Dear ' + userName +',' ;   
             body += '<p style="font-family:Calibri,Candara,Segoe,Segoe UI,Optima, times, serif;">';
             body += 'The following project is due to close on '+record.closeDate   + '</br>';
             body +='<a href="https://emea.salesforce.com/'+record.id+'" style="text-decoration:none;">' +record.name+'</a></br>'+'</br>';
             body += 'Please review and update the close date accordingly.'+'</br>'+'</br></p>'; 
             body += '</body></html>';                
    		 mail.setHtmlBody(body);
             system.debug('DATA: ------------ ' + userEmail  + ' ' + userName + ' ' + record.name);
            }
                
                return mail;
    }
        
        
    public  void finish(Database.BatchableContext context) { }

    public  void execute(SchedulableContext context)
    {    system.debug('BatchActivityDate - execute 1');
        Database.executeBatch(this);
    }
}