trigger MasterLeadTrigger on Lead  (before insert, after insert, before update, after update,  before delete, after delete, after undelete) {
  
  // custom settings control
  if(TriggerControl__c.getValues('LeadTrigger') != null){
    if (Trigger.isBefore) {
       Map <Id, Lead> insertLeadNew;
        
    	if (Trigger.isInsert) {
           if(TriggerControl__c.getValues('LeadTriggerBeforeInsert') != null){ 
               
           insertLeadNew = new Map<Id,Lead>();
            for(Lead a : trigger.new)
                insertLeadNew.put(a.Id,a); 
                  
            ClassLeadHandler bhandler = new ClassLeadHandler(insertLeadNew, Trigger.oldMap);
            // Lead Quality Score
            bhandler.LeadQualityScore();
            // suggested Email
            bhandler.SuggestedEmail();
          }
        } 
   	    if (Trigger.isUpdate) {
              if(TriggerControl__c.getValues('LeadTriggerBeforeUpdate') != null){ 
         
            ClassLeadHandler bhandler = new ClassLeadHandler(Trigger.newMap, Trigger.oldMap); 
            // Lead Quality Score
            bhandler.LeadQualityScore();
            //suggested Email
            bhandler.SuggestedEmail();
             
            }
   		 }
        if (Trigger.isDelete) { }
  	}

    if (Trigger.IsAfter) {
       
     
         
   	    if (Trigger.isUpdate) {
            
     		ClassLeadHandler ahandler = new ClassLeadHandler(Trigger.newMap, Trigger.oldMap); 
            //countLeadsAt Account
            ahandler.LeadsAtAccount();
        
            
        }
       	  if (Trigger.isInsert) {
                if(TriggerControl__c.getValues('LeadTriggerAfterInsert') != null){ 
                    
               Map <Id, Lead> insertLeadNew;
                 insertLeadNew = new Map<Id,Lead>();
                 for(Lead a : trigger.new)
                  insertLeadNew.put(a.Id,a);
             
             ClassLeadHandler ahandler = new ClassLeadHandler(  insertLeadNew , null);  
            //countLeadsAt Account
            ahandler.LeadsAtAccount();
            // Lead Link Account
            ahandler.LinkLeadToAccount();
            // Lead Gen profiles - > stage to Qualified Lead
            ahandler.LeadGenQualifiedLeads();
                
           }      
        }
        
   	    if (Trigger.isDelete) {
              if(TriggerControl__c.getValues('LeadTriggerAfterDelete') != null){ 
           
            ClassLeadHandler ahandler = new ClassLeadHandler(Trigger.oldMap, Trigger.oldMap); 
            //countLeadsAt Account
            ahandler.LeadsAtAccount();
                  
           }
        }
        
       if (Trigger.isUndelete) {
             if(TriggerControl__c.getValues('LeadTriggerAfterUnDelete') != null){ 
              
            ClassLeadHandler ahandler = new ClassLeadHandler(Trigger.newMap, Trigger.oldMap); 
            //countLeadsAt Account
            ahandler.LeadsAtAccount();
              
            }
          }
       
       }
           
    }  
 	 
}