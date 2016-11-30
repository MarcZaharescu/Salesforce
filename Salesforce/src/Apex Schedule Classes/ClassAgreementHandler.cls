public class ClassAgreementHandler {
 
   
    Map<ID,Agreement__c> newAgreements;  
    Map<ID,Agreement__c> oldAgreements;  
    
    
    public ClassAgreementHandler(Map<ID,Agreement__c> newTriggerAgreements,Map<ID,Agreement__c> oldTriggerAgreements){
        newAgreements=newTriggerAgreements;
        oldAgreements=oldTriggerAgreements;
    }
    
     /* link Contactid and opportunityid on Agreement
     * 
     * 
     * 
     * 
     * 
     * 
     * 
     */
     
    public void linkContactidAgreement()
        {
            
        Set<String> contactids = new Set<String>();
        Set<String> opportunityids = new Set<String>();
        Set<String> applicationids= new Set<String>();
            
        for(Agreement__c a : newAgreements.values()){
            if(a.application_id__c!=null)
            { 
                contactids.add(a.contact_id__c);
                opportunityids.add(a.Project_id__c);
            	applicationids.add(a.Application_id__c);
            }
        }
        
        List<Contact> contactList = [Select id,Mbacoid__c from Contact where MBACOID__c in: contactids];
        List<opportunity> opportunityList = [Select id, MBACOID__c from Opportunity where 	MBACOID__c in: opportunityids];
        List<Application__c> applicationList = [Select id, Application_Id__c from Application__c where Application_id__c in: applicationids];
            
        Map< String , id > contactMap= new Map< String , id>();
        Map< String , id > opportunityMap= new Map< String , id>();
        Map< String ,id> applicationMap = new Map< String, id>();
            
        List<Agreement__c> applicationsToUpdate = new List<Agreement__c>();
        for(Contact c : contactList){
               contactMap.put( c.MBACOID__c, c.id );            
        }
            
        for(Opportunity o : opportunityList){
               opportunityMap.put( o.MBACOID__c, o.id );            
        }
        
        for(Application__c a: applicationList)
        {
            applicationMap.put(a.application_id__c, a.id);
        }
            
            if (contactMap.size() > 0 || opportunityMap.size()>0) {
            Agreement__c[] updates = new Agreement__c[] {};
            
            for (Agreement__c a: newAgreements.values()) {
                 Id contactId,opportunityId,applicationId;
                
                if (a.Contact_id__c != null)  
                    contactId = contactMap.get(a.Contact_id__c);
                if(a.Project_id__c!=null)
                     opportunityId= opportunityMap.get(a.project_id__c);
                if(a.Application_id__c!=null)
                     applicationId=applicationMap.get(a.application_id__c);
                   
                    Agreement__c app= new Agreement__c(Id = a.Id);
                    
                    if (contactId != null) {
                       app.Contactid__c = contactId;
                    }
                    
                    if(opportunityId !=null){
                        app.Projectid__c=opportunityId;
                    }
                
                    if(applicationId!=Null)
                        app.Applicationid__c=applicationId;
                    
                if(opportunityId !=null || contactid!=null)
                    updates.add(app);
                   
             }
                      
                 update updates;
               
          

            }
    
               
    }
}