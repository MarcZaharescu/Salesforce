public class ClassLeadHandler {
   
    Map<ID,Lead> newLeads = new Map<id,Lead>();  
    Map<ID,Lead> oldLeads = new Map<id,Lead>();  
    
    
    public ClassLeadHandler(Map<ID,Lead> newTriggerLeads,Map<ID,Lead> oldTriggerLeads){
        newLeads=newTriggerLeads;
        oldLeads=oldTriggerLeads;
    }
    
    
      /*   Lead Qualified Lead Status
     * 
     * 
     * 
     * 
     * 
     * 
     */
  public void QualifiedLeadStatus(){
         
       Set<ID> accountIds = new Set<ID>();
       for (Lead l : newLeads.values()) {
           
            if( (l.Act_on_Behavior_Score__c>0 && l.Calculated_Lead_Score__c>=20)  && (l.Status=='Pre Qualified Lead' || l.Status=='Sales Development Lead' ||  l.Status=='Return To Marketing' )){  
          
             l.Status='Qualified Lead';
             l.QL_Date__c=Date.today();          
       }
     }  
  }
    
        /*   LeadGen -> Qualified Leads * 
     * 
     * 
     * 
     * 
     * 
     */
    public void LeadGenQualifiedLeads()
    {   
        Map<Id,Profile> profileIds = new Map<id,profile>([SELECT Id  FROM Profile where name ='Lead Generation' ]);
       
        Set<id> ids = new Set<id>();        
        Map<Id,user> leadgenProfileUsers = new  Map<Id,user>([select  id  from user where profileId in:profileIds.Keyset() and isActive=true]);
        
       
        for(Lead l: newLeads.values())  
        {    
            if((l.status=='Pre Qualified Lead'|| l.status=='') && leadgenProfileUsers.get(l.createdbyid)!=null ) 
            {
            ids.add(l.id);
            }
        }
        
       List<lead> LeadsToUpdate = [Select id, status from lead where id in: ids];
       for(Lead l : leadsToUpdate)
             l.status='Qualified Lead';
        
        
        update leadstoupdate;

    }
    
    
    
    
    /*   Lead Quality Score
     * 
     * 
     * 
     * 
     * 
     * 
     */
    
  public void LeadQualityScore(){
         
       Set<ID> accountIds = new Set<ID>();
       for (Lead l : newLeads.values()) {
        Double count=0;          
       
         if( (l.name)!=NULL )
            count=count+1;  
         if( (l.salutation)!=NULL)
              count=count+1; 
         if( (l.function__c)!=NULL)
             count=count+1; 
         if( (l.company)!=NULL)
            count=count+1; 
         if(l.MobilePhone!=NULL)
            count=count+1;
         if( (l.Phone)!=NULL)
            count=count+1;
         if( (l.email)!=NULL)
           count=count+1;
         if( (l.secondary_email__c)!=NULL)
           count=count+1;
         if( (l.leadsource)!=NULL)
           count=count+1;
         if( (l.account__c)==NULL)
         count=0; 
         else{ 
             count=count+1;
             } 
        
        l.Lead_Quality_Score__c=count;
     
    }
  }       
      
    public void LeadsAtAccount() {
     
      Set<Id> acctIds = new Set<Id>();
     
     if(newLeads!=null){
      for (Lead l : newLeads.values()) {
        if (l.Account__c != null) {
            acctIds.add(l.Account__c);
        }
    }
   }
        
    List<Account> acctsToRollup = new List<Account>();
    for (AggregateResult ar : [SELECT Account__c AcctId, Count(id) LeadCount 
                               FROM Lead  
                               WHERE Account__c in: acctIds
                               GROUP BY Account__C]){
        Account a = new Account();
                                  
        a.Id = (Id) ar.get('AcctId');
        a.Lead_Count__c = (Integer) ar.get('LeadCount');
        acctsToRollup.add(a);
                     
    }

    update acctsToRollup; 
   }
    
    
   /* Link Lead to Account
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
    
public void LinkLeadToAccount() {

    Set<String> companies = new Set<String>();
    for (Lead l: newLeads.values()) {
        if (l.Company != null) companies.add(l.Company);
    }

    if (companies.size() > 0) {

        // Pick most recent Account where more than one with same name
        Map<String, Id> accountNameToId = new Map<String, Id>();
        for (Account a : [
                select Name, Id
                from Account
                where Name in :companies
                order by CreatedDate
                ]) {
            accountNameToId.put(a.Name, a.Id);
        }

        if (accountNameToId.size() > 0) {
            Lead[] updates = new Lead[] {};
            for (Lead l: newLeads.values()) {
                if (l.Company != null) {
                    Id accountId = accountNameToId.get(l.Company);
                    if (accountId != null) {
                        updates.add(new Lead(Id = l.Id, Account__c = accountId));
                    }
                }
            }
 
            update updates;
        }
    }
}
   
   
 
    
  
 
     
    /*  Suggested Email Lead
     * 
     * 
     * 
     * 
     * 
     * 
     *
     */
    
  
    
    
  public void  SuggestedEmail(){
   
      for(Lead l: newLeads.values()){
          
         String format=l.Lead_Email_Format__c;
         String ending=l.Lead_Email_Ending__c;  
         l.Suggested_Email__c=format;
           
          if(format=='firstname.lastname'){    
           l.Suggested_Email__c=(l.FirstName+'.'+l.LastName+ending).toLowerCase();
           }
         
          if(format=='lastname.firstname'){
           l.Suggested_Email__c=(l.LastName+'.'+l.FirstName+ending).toLowerCase();
           }
          
          if(format=='firstinitial.lastname') {
           l.Suggested_Email__c=(l.FirstName.substring(0,1)+'.'+l.LastName+ending).toLowerCase();
           }
             
          if(format=='firstinitial+lastname'){
           l.Suggested_Email__c=(l.FirstName.substring(0,1)+l.LastName+ending).toLowerCase();
           }
           
          if(format=='firstname+lastname'){
           l.Suggested_Email__c=(l.FirstName+l.LastName+ending).toLowerCase();
           }
            
           if(format=='lastname+firstname'){
            l.Suggested_Email__c=(l.LastName+l.FirstName+ending).toLowerCase();
           }
               
        }  
   }
    
    
        
        
    
 
     
 

}