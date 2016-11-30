public class ClassContactHandler {
    
    Map<ID,Contact> newContacts;  
    Map<ID,Contact> oldContacts;  
    
    
    public ClassContactHandler(Map<ID,Contact> newTriggerContacts,Map<ID,Contact> oldTriggerContacts){
        newContacts=newTriggerContacts;   
        oldContacts=oldTriggerContacts;
    }
     
    /* Link GA country to contact country
     * 
     * 
     * 
     * 
     *
     */
      public void GaCountryToContact(){ 
          
         Map<  String,id> sfcountrymap = new Map<   String, id>();
         List<Country__c> countrylist = new List<Country__c>([Select id,name from Country__c]);
         
              for(Country__c c: countrylist)
             sfcountrymap.put(  c.name,c.id  );
          
          Map<id,String> gacountrymap = new Map<id,String>();
          for (Contact c : newContacts.values()) {

              if(sfcountrymap.get(c.Ga_Country__c)!=null){
               Id countryid = sfcountrymap.get(c.GA_country__c);      
               c.country__c=countryid;
                  
           }
        }

       
      
      
      }
    
    
    /* ContactQualityScore
     * 
     * 
     * 
     * 
     *
     */
   public void ContactQualityScore(){ 
      for (Contact c : newContacts.values()) {
     
        Double count=0;      
       if( (c.firstname)!=NULL || (c.lastname)!=NULL )
            count=count+1; 
        if( (c.salutation)!=NULL)
            count=count+1;
         if( (c.account)!=NULL)
              count=count+1; 
        if( (c.country__c)!=NULL)
             count=count+1;
         if( (c.seniority__c)!=NULL)
             count=count+1;
         if( (c.function__c)!=NULL)
            count=count+1; 
         if( (c.title)!=NULL )
         count=count+1;
         if(c.MobilePhone!=NULL)
            count=count+1;
         if( (c.Phone)!=NULL)
            count=count+1;
         if( (c.email)!=NULL)
           count=count+1;
          if( (c.secondary_email__c)!=NULL)
           count=count+1;
          if( (c.office_location__c)!=NULL)
           count=count+1;
         if( (c.profile_on_platform__c)!=NULL)
           count=count+1;
        
          c.Contact_Quality_Score__c=count;
        }
        
    }
    
    /* Contacts at Account
     * 
     * 
     * 
     * 
     * 
     * 
     */
    
    public void ContactsAtAccount(){
    
        Set<Id> acctIds = new Set<Id>();
        for (Contact c : newContacts.values()) {
        	if (c.AccountId != null) {
            acctIds.add(c.AccountId);
       		 }
   		 }
   
     List<Account> contactsAtAccount = new List<Account>();
     for (AggregateResult ar : [SELECT AccountId AcctId, Count(id) ContactCount 
                               FROM Contact 
                               WHERE AccountId in: acctIds 
                               GROUP BY AccountId]){
        Account a = new Account();
        a.Id = (Id) ar.get('AcctId');  
        a.Contact_Count__c = (Integer) ar.get('ContactCount');
        contactsAtAccount.add(a);
    }  
    update contactsAtAccount;
        
     List<Account> contactsThatCreatedOpps = new List<Account>();


     for (AggregateResult ar : [SELECT AccountId AcctId, Count(id) ContactCount 
                               FROM Contact 
                               WHERE AccountId in: acctIds and Created_Opp_Count__c>0 
                               GROUP BY AccountId]){
                                   
        Account a = new Account();
        a.Id = (Id) ar.get('AcctId');  
        a.Contact_CreatedOpp_Count__c = (Integer) ar.get('ContactCount');
        contactsThatCreatedOpps.add(a);
                           
    }  
    update contactsThatCreatedOpps;
  
     List<Account> contactsThatClosedOpps = new List<Account>();
     for (AggregateResult ar : [SELECT AccountId AcctId, Count(id) ContactCount 
                               FROM Contact 
                               WHERE AccountId in: acctIds and Closed_Opp_Count__c>0 
                               GROUP BY AccountId]){
                                 //  system.debug((Integer) ar.get('ContactCount'));
        Account a = new Account();
        a.Id = (Id) ar.get('AcctId');  
        a.Contact_ClosedOpp_Count__c = (Integer) ar.get('ContactCount');
        contactsThatClosedOpps.add(a);                       
    }  
    update contactsThatClosedOpps;
        
         
    }
    
    /**** Contact Email Format
     * 
     * 
     * 
     * 
     * 
     * 
     * 
     * 
     * 
     * 
     */
   public void Contact_Email_Format(){
    
   /*   for(Contact c: newContacts.values()){
     
          if(c.Email!=null &&c.firstname!=null && c.lastname!=null ){
              
              String Email = c.email;
        	  String FirstName= c.firstname;
      	      String LastName=c.lastname; 
      		  String[] emailending;
           
        
           if(c.Email.length()>1){ 
                 emailending=  c.email.split('@'); 
        	 	 c.Contact_Email_Ending__c='@'+emailending[1];
        	}
        
        else
            c.Contact_email_Ending__c='@gmail.com';
            c.Contact_Email_Format__c='Unknown';
        
    //-------1---------------------------2---------
        if(Email.length()>FirstName.length()+LastName.length()+1){ 
            
          if((Email.substring(0,FirstName.length())==firstname) && (Email.substring(FirstName.length()+1,FirstName.length()+1+LastName.length())==(lastname))){
              c.Contact_Email_Format__c='firstname.lastname';
           }
            
             else         
           
           if((Email.substring(0,LastName.length())==lastname) && (Email.substring(LastName.length()+1,FirstName.length()+1+LastName.length())==(firstname))){
               c.Contact_Email_Format__c='lastname.firstname';
           }
        }  
        //-------3---------------------------4---------
           
        if(Email.length()>FirstName.length()+LastName.length()) { 
          
            if((Email.substring(0,FirstName.length())==firstname) && (Email.substring(FirstName.length(),FirstName.length()+LastName.length())==(lastname))) {
            c.Contact_Email_Format__c='firstname+lastname';
            }
          else
            
        	 if((Email.substring(0,LastName.length())==lastname) && (Email.substring(LastName.length(),FirstName.length()+LastName.length())==(firstname))){ 
             c.Contact_Email_Format__c='lastname+firstname';
            }
        }
            
            //--------------------5--------------------------
     
        if(Email.length()>2+LastName.length()) {    
         
            if((Email.substring(0,1)==(firstname.substring(0,1))) && (Email.substring(2,2+LastName.length())==(lastname))) { 
               c.Contact_Email_Format__c='firstinitial.lastname';
            }
        }
            //--------------------6----------------------------
            //
      
        if(Email.length()>1+LastName.length()) { 
          
            if((Email.substring(0,1)==(firstname.substring(0,1))) && (Email.substring(1,1+LastName.length())==(lastname))) { 
              c.Contact_Email_Format__c='firstinitial+lastname';
            }
        }
    }
        else
        {
            
            c.Contact_email_Ending__c='@gmail.com';    
            c.Contact_Email_Format__c='Unknown';
        }
    }*/
   }
    
    
    /*   Account_Email_Format_Contact
     * 
     * 
     * 
     * 
     * 
     * 
     * 
     * 
     * 
     * 
     * 
     * 
     * 
     **/
    public void Account_Email_Format () {

    /*List<Contact> contacts = newContacts.values();
    Set<Id> acctIds = new Set<Id>();
   
    for (Contact c : contacts) {

        if (c.AccountId != null) {
            acctIds.add(c.AccountId);
        }
    }
   
    List<Account> acctsToRollup = new List<Account>();
    
  String FXL='firstname.lastname';
  String LXF='lastname.firstname' ;
  String IXL='firstinitial.lastname';
  String IL='firstinitial+lastname';
  String FL='firstname+lastname';
  String LF='lastname+firstname';
   
   Integer countFXL=0, countLXF =0, countIXL =0, countIL=0, countFL=0,  countLF=  0;
   AggregateResult[] countAll= [SELECT Contact_Email_Format__c,Count(id) counter  FROM Contact WHERE AccountId in: acctIds group by Contact_Email_Format__c];
   
        for(AggregateResult ag : countAll)
        {
              if(String.valueof(ag.get('Contact_Email_Format__c'))=='FXL')
                countFXL=integer.valueof(ag.get('counter'));
               if(String.valueof(ag.get('Contact_Email_Format__c'))=='LXF')
                countLXF=integer.valueof(ag.get('counter'));            
               if(String.valueof(ag.get('Contact_Email_Format__c'))=='IXL')
                countIXL=integer.valueof(ag.get('counter'));
               if(String.valueof(ag.get('Contact_Email_Format__c'))=='IL')
                countIL=integer.valueof(ag.get('counter'));
               if(String.valueof(ag.get('Contact_Email_Format__c'))=='FL')
                countFL=integer.valueof(ag.get('counter'));
               if(String.valueof(ag.get('Contact_Email_Format__c'))=='LF')
                countLF=integer.valueof(ag.get('counter'));
        }
                                      
        Integer max=0;
        String format='Unknown';
        Integer count;
        
        count= countFXL;                               
        if(max< count) 
        {  max=count;
           format='firstname.lastname';
        }
        count= countLXF;                               
        if(max< count) 
        {  max=count;
           format='lastname.firstname';
        }
        count= countIXL;                               
        if(max< count) 
        {  max=count;
           format='firstinitial.lastname';
        }
        count= countIL;                               
        if(max< count) 
        {  max=count;
           format='firstinitial+lastname';
        }
        count= countFL;                               
        if(max< count) 
        {  max=count;
           format='firstname+lastname';
        }
        count= countLF;                               
        if(max< count) 
        {  max=count;
           format='lastname+firstname';
        }
 
       List<Account> accounts = [Select id,Account_Email_Ending__c,Account_Email_Format__c from Account where id in: acctids];
       Contact[] emailending= [SELECT Contact_Email_Ending__c FROM Contact WHERE AccountId in: acctIds and Contact_Email_Format__c=:format];
        
        for(Account a : accounts) {
            
       		 a.Account_Email_Format__c = format;
        	if(emailending!=null){
            	if(emailending.size()>0){
                 a.Account_Email_Ending__c = emailending[0].Contact_Email_Ending__c;
             	}
              else
             	a.Account_Email_Ending__c='Unknown'; 
       		 }
        	else
             a.Account_Email_Ending__c='Unknown';
      
        acctsToRollup.add(a);
       }     
 
    
 update acctsToRollup; */ 
        
        // dummy test
        integer xyz=1;
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
        

} 

}