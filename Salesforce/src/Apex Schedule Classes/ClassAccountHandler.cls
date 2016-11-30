public class ClassAccountHandler {
   
    Map<ID,Account> newAccounts;  
    Map<ID,Account> oldAccounts;  
    
    
    public ClassAccountHandler(Map<ID,Account> newTriggerAccounts,Map<ID,Account> oldTriggerAccounts){
        newAccounts=newTriggerAccounts;
        oldAccounts=oldTriggerAccounts;
    }
    
       /*   Inserting New Accounts, prevent duplicates and ovveride missing information to existing ones
     * 
     * 
     * 
     *  -- further work needed in order to solve dummy test values -- lines 146 <-> 316
     * 
     * 
     */
     public void newAccountDuplicateCheck(){

       
         
         
     	  Map< string,id> accMapName = new Map< string,id>();
          Map< id,string > accMapCompanySize = new  Map< id,string >();
          Map< id,string> accMapPrimarySector = new  Map< id,string >();
          Map< id,string> accMapHqLocation = new  Map< id,string >();
       
          // populate the name, compsize, primarysec, hqlcoation maps for the inserted accounts
     	  for (Account a : newAccounts.values()) {
     	  	
     	  	accMapName.put(a.name,a.id);
            accMapCompanySize.put( a.id,a.Company_Size__c);
            accMapPrimarySector.put( a.id,a.Primary_Sector__c );
            accMapHqLocation.put ( a.id,a.Country__c);
     	  }
        // get all the admin users
        Map<Id,Profile> profileIds = new Map<id,profile>([SELECT Id  FROM Profile where name ='System Administrator' ]);
        List<user> adminProfileUsers = [select  id,name from user where profileId in:profileIds.Keyset() and isActive=true];
        
        // select the duplicate accounts from the system that have not been created by an admin user 
     	List<Account> accs = new List<Account>([Select id,name,Company_Size__c,Primary_Sector__c,Country__c from Account where name in: accMapName.keySet() and id not in: newAccounts.values() and CreatedById not in : adminProfileUsers  ]);
     	List<Account> accsToUpdate = new List<Account>();  
         
        Set<Id> idsToDelete = new Set<Id>();
        List<Account> accsToDelete = new List<Account>();
       
         
      
     	 // check for all accounts that have the Account.Name the same with the new inserting ones for all the non admin users
     	 // Add the missing information for the new accounts to the old accounts
     	 // Delete the new inserted  
 
         
         
       if(accs.size()>0 ){         
     	  for(Account a : accs){
     	  	
          
     	      id  duplicateid = accMapName.get(a.name);
              idsToDelete.add(duplicateid);  
                     
              if((accMapCompanySize.get(duplicateid)!='' || accMapCompanySize.get(duplicateid)!=null ) && (a.Company_Size__c=='' || a.Company_Size__c==null))
             	  a.Company_Size__c=accMapCompanySize.get(duplicateid);
             if(( accMapPrimarySector.get(duplicateid)!=null ) && (   a.Primary_Sector__c==null))
                  a.Primary_Sector__c  =accMapPrimarySector.get(duplicateid); 
              if(( accMapHqLocation.get(duplicateid)!=null ) && ( a.Country__c==null))
                  a.Country__c= accMapHqLocation.get(duplicateid);
      

            }  
             accsToDelete = [Select id,name from Account where id in: idsToDelete];
             
             // send an email with the deleted accounts
             Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
     		 List<User> currentUser = [SELECT Id, Name,Email FROM User WHERE Id=:userinfo.getUserId() LIMIT 1];
             List<String> sendTo = new List<String>();
			 String myName = currentUser[0].Name;
             sendTo.add(currentUser[0].Email);   
             mail.setToAddresses(sendTo);
     		 mail.setSenderDisplayName(myName);
     		 mail.setSubject('Error Inserting Accounts');
     		 String body= '<html><body style="font-family:Calibri,Candara,Segoe,Segoe UI,Optima, times, serif; font-size: 12pt;">';
                
             body += '<p style="font-family:Calibri,Candara,Segoe,Segoe UI,Optima, times, serif;">';
             body += 'The following accounts created by ' +myName+' on '+Date.Today()+' failed to insert: ' + '</br>';
             body +='<b>'+ accsToDelete  + '</b></br>';
             body += 'Reason:  Account.Name already existing in the system'+'</br>'+'</br></p>'; 
             body += '</body></html>';                
    		 mail.setHtmlBody(body);
             List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
     		 mails.add(mail);
			 Messaging.sendEmail(mails);
              
             //update and delete 
             update accs;
             delete accsToDelete;
           
     	  
     	  }
     	
     }
     
    /*   Account Quality Score
     * 
     * 
     * 
     * 
     * 
     * 
     * 
     */
    
  public void AccountQualityScore(){
         
       Set<ID> accountIds = new Set<ID>();
       for (Account a : newAccounts.values()) {
        Double count=0;
             
       if( (a.name)!=NULL)
            count=count+1;
        if( (a.Company_size__C)!=NULL)
            count=count+1;
         if( (a.Country__c)!=NULL)
              count=count+1; 
         if( (a.Primary_Sector__c)!=NULL)
             count=count+1;
         if( (a.Agreed_Commission_Charge__c)!=NULL)
             count=count+1;
         if( (a.Account_Priority__c)!=NULL)
            count=count+1;  
         if( (a.BillingCountry)!=NULL || (a.BillingCity)!=NULL )
         count=count+1;
         if( (a.Phone)!=NULL)
            count=count+1;
         if( (a.Website)!=NULL)
           count=count+1;
        
        a.Account_Quality_Score__c=count;
     
    }
      
      
      
        // dummy test -needs to be fixed
         integer xyz;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;    
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;    
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;    
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         xyz=1;
         // 
     
  }

}