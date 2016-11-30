trigger MasterEventTrigger on Event (before insert, after insert, before update, after update,  before delete, after delete) {
  
  // custom settings control
  if(TriggerControl__c.getValues('EventTrigger') != null){
      
    if (Trigger.isBefore) {
         Map <Id, Event> insertEventNew;
           
        
      if (Trigger.isInsert) {
          if(TriggerControl__c.getValues('EventTriggerBeforeInsert') != null){ 
            // create the new map for before insert state
            insertEventNew = new Map<Id, Event>();
            for(Event t : trigger.new)
                insertEventNew.put(t.Id, t); 
            
            //add client status to Events
            ClassEventHandler bhandler = new ClassEventHandler (insertEventNew,Trigger.oldMap);
            bhandler.addClientStatus();
          }
        } 
       if (Trigger.isUpdate) {
		   if(TriggerControl__c.getValues('EventTriggerBeforeUpdate') != null){ 
            ClassEventHandler bhandler = new ClassEventHandler (Trigger.newMap, Trigger.oldMap);
            //add client status to Events
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
         Map <Id, Event> insertEventNew;
         Map <Id, Event> insertEventOld;
        
        if (Trigger.isInsert) {
          if(TriggerControl__c.getValues('EventTriggerAfterInsert') != null){ 
            
        // create the new map for before insert state
        insertEventNew = new Map<Id, Event>();
        for(Event t : trigger.new)
            insertEventNew.put(t.Id, t);         
               
        ClassEventHandler ahandler = new ClassEventHandler(Trigger.newMap, null);
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
               if(TriggerControl__c.getValues('EventTriggerAfterUpdate') != null){ 
         
       
        ClassEventHandler ahandler = new ClassEventHandler(Trigger.newMap, Trigger.oldMap);
        // count the activities on leads  
        ahandler.LeadActivityCount();
        // send event notifiction email
        ahandler.sendNotificationEmail();
        
          }    
        }
        
        if (Trigger.isDelete) {   
             if(TriggerControl__c.getValues('EventTriggerAfterDelete') != null){   
            
        // count the activities on leads      
        ClassEventHandler ahandler = new ClassEventHandler(Trigger.newMap, Trigger.oldMap);
        ahandler.LeadActivityCount();
        
             }      
        }
   }
    
 } 
       
}