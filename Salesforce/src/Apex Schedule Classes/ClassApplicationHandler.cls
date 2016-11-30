public class ClassApplicationHandler {
 
   
    Map<ID,Application__c> newApplications;  
    Map<ID,Application__c> oldApplications;  
    
    
    public ClassApplicationHandler(Map<ID,Application__c> newTriggerApplications,Map<ID,Application__c> oldTriggerApplications){
        newApplications=newTriggerApplications;
        oldApplications=oldTriggerApplications;
    }
    
     /* link Contactid and opportunityid on Application
     * 
     * 
     * 
     * 
     * 
     * 
     * 
     */
     
    public void linkContactidApplication()
        {
            
        Set<String> contactids = new Set<String>();
        Set<String> opportunityids = new Set<String>();
        for(Application__c a : newApplications.values()){
            if(a.contactid__c!=null){ 
                contactids.add(a.contactid__c);
                opportunityids.add(a.opportunityid__c);}
        }
        
        List<Contact> contactList = [Select id,Mbacoid__c from Contact where MBACOID__c in: contactids];
        List<opportunity> opportunityList = [Select id, MBACOID__c from Opportunity where 	MBACOID__c in: opportunityids];
            
        Map< String , id > contactMap= new Map< String , id>();
        Map< String , id > opportunityMap= new Map< String , id>();  
            
        List<Application__c> applicationsToUpdate = new List<Application__c>();
        for(Contact c : contactList){
               contactMap.put( c.MBACOID__c, c.id );            
        }
            
        for(Opportunity o : opportunityList){
               opportunityMap.put( o.MBACOID__c, o.id );            
        }
            
            if (contactMap.size() > 0 || opportunityMap.size()>0) {
            Application__c[] updates = new Application__c[] {};
            
            for (Application__c a: newApplications.values()) {
                 Id contactId,opportunityId;
                
                if (a.Contactid__c != null)  
                    contactId = contactMap.get(a.Contactid__c);
                if(a.Opportunityid__c!=null)
                     opportunityId= opportunityMap.get(a.Opportunityid__c);
                   
                    Application__c app= new Application__c(Id = a.Id);
                    
                    if (contactId != null) {
                       app.Contact_id__c = contactId;
                    }
                    
                    if(opportunityId !=null){
                         app.Opportunity_id__c=opportunityId;
                    }
                    
                if(opportunityId !=null || contactid!=null)
                    updates.add(app);
                   
             }
                
                 update updates;
               
          

            }
    
               
    }
    
    /*  Application Count on Opportunity
     * 
     * 
     * 
     * 
     * 
     * 
     * 
     */
 
    public void AppCountOnOpportunity(){
    
    Set<id> oppIds = new Set<id>();
    Map<id, integer> allApplications = new Map<id, integer>();
    integer count;
    for(Application__c app :  newApplications.values())
    {	
        if(app.Opportunity_id__c!=null)
        {       
           
            if(allApplications.get(app.Opportunity_id__c)==null)
            {     
               
                count =1;
                allApplications.put(app.Opportunity_id__c,1);
            } 
            else
            { 
               count = allApplications.get(app.Opportunity_id__c);
               allApplications.put(app.Opportunity_id__c,(count+1));
             
            }
        }
        
    }
        List<Opportunity> oppsToUpdate = [Select id,Total_Applications__c from Opportunity where id in : allApplications.keySet()];
       
        for(Opportunity opp: oppstoUpdate)
        {
            if(allApplications.get(opp.id)!=null)
            {
                integer i= allApplications.get(opp.id);
           		opp.Total_applications__c=i;
                     
             }
        }
        
        update oppstoUpdate;
       
        
    }
         
        
         

}