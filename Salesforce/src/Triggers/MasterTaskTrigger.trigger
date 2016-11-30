trigger MasterTaskTrigger on Task (before insert, after insert, before update, after update,  before delete, after delete) {
  
  // custom settings control
  if(TriggerControl__c.getValues('TaskTrigger') != null){
    if (Trigger.isBefore) {
         Map <Id, Task> insertTaskNew;
           
        
      if (Trigger.isInsert) {
          if(TriggerControl__c.getValues('TaskTriggerBeforeInsert') != null){ 
            // create the new map for before insert state
            insertTaskNew = new Map<Id, Task>();
            for(Task t : trigger.new)
                insertTaskNew.put(t.Id, t); 
            
            //add client status to Tasks
            ClassTaskHandler bhandler = new ClassTaskHandler (insertTaskNew,Trigger.oldMap);
            bhandler.addClientStatus();
          }
        } 
       if (Trigger.isUpdate) {
		   if(TriggerControl__c.getValues('TaskTriggerBeforeUpdate') != null){ 
            ClassTaskHandler bhandler = new ClassTaskHandler (Trigger.newMap, Trigger.oldMap);
            //add client status to Tasks
            bhandler.addClientStatus();
            // last activity on contact
            bhandler.LastContactActivityDate();
            // update lead status if contacted - not being used anymore
          //bhandler.UpdateLeadStatusIfContacted();
          }
       }
        if (Trigger.isDelete) { }
    }

    if (Trigger.IsAfter) {
         Map <Id, Task> insertTaskNew;
         Map <Id, Task> insertTaskOld;
        
        if (Trigger.isInsert) {
          if(TriggerControl__c.getValues('TaskTriggerAfterInsert') != null){ 
            
        // create the new map for before insert state
        insertTaskNew = new Map<Id, Task>();
        for(Task t : trigger.new)
            insertTaskNew.put(t.Id, t);         
               
        ClassTaskHandler ahandler = new ClassTaskHandler(Trigger.newMap, null);
        // count the activities on leads   
        ahandler.LeadActivityCount();
        // last activity on contact
        ahandler.LastContactActivityDate();
        // update lead status if contacted  - not being used anymore
        // ahandler.UpdateLeadStatusIfContacted();
        // send event notifiction email
        ahandler.sendNotificationEmail();
          
          }
        }  
        
        if (Trigger.isUpdate) {
               if(TriggerControl__c.getValues('TaskTriggerAfterUpdate') != null){ 
         
       
        ClassTaskHandler ahandler = new ClassTaskHandler(Trigger.newMap, Trigger.oldMap);
        // count the activities on leads  
        ahandler.LeadActivityCount();
        // send event notifiction email
        ahandler.sendNotificationEmail();
        
          }    
        }
        
        if (Trigger.isDelete) {   
             if(TriggerControl__c.getValues('TaskTriggerAfterDelete') != null){   
            
        // count the activities on leads      
        ClassTaskHandler ahandler = new ClassTaskHandler(Trigger.newMap, Trigger.oldMap);
        ahandler.LeadActivityCount();
        
             }      
        }
   }
    
 } 
       
}