trigger MasterApplicationTrigger on Application__c  (before insert, after insert, before update, after update,  before delete, after delete) 
{ 
   
   // custom settings control
   if(TriggerControl__c.getValues('ApplicationTrigger') != null)
   { 
    if (Trigger.isBefore) {
       Map <Id, Application__c > insertApplicationNew;
        
    	if (Trigger.isInsert) {
             if(TriggerControl__c.getValues('ApplicationTriggerBeforeInsert') != null){ 
       			 insertApplicationNew = new Map<Id,Application__c>();
           		 for(Application__c a : trigger.new)
               	 insertApplicationNew.put(a.Id,a); 
               
             ClassApplicationHandler bhandler = new ClassApplicationHandler(insertApplicationNew, Trigger.oldMap);
             // count applications on opportunity
             bhandler.AppCountOnOpportunity();
             }  

        } 
   	    if (Trigger.isUpdate) {
            if(TriggerControl__c.getValues('ApplicationTriggerBeforeUpdate') != null){ 
                //check for recursive behaviours
                if(RecursionControl.firstRunBefore==true) { 
                  ClassApplicationHandler bhandler = new ClassApplicationHandler(Trigger.newMap, Trigger.oldMap);
                  // count applications on opportunity    
                  bhandler.AppCountOnOpportunity(); 
                  RecursionControl.firstRunBefore=false;
                }
          }
        }
        if (Trigger.isDelete) { }
  	}

    if (Trigger.IsAfter) {
     
   	    if (Trigger.isUpdate) {
            
           if(TriggerControl__c.getValues('ApplicationTriggerAfterUpdate') != null){ 
              //check for recursive behaviours
              if(RecursionControl.firstRunAfter==true) { 
                ClassApplicationHandler ahandler = new ClassApplicationHandler(Trigger.newMap, Trigger.oldMap);
                //link contacts, projects to the application
                //
                //ERROR 101- SOQL Queries, needs further investigation
                //
                // ahandler.linkContactidApplication();
                RecursionControl.firstRunAfter=false;
              }
           }
     
        }   
       	       

        if (Trigger.isInsert) {
             if(TriggerControl__c.getValues('ApplicationTriggerAfterInsert') != null){ 
       		
                 Map <Id, Application__c> insertApplicationNew;
                 insertApplicationNew = new Map<Id,Application__c>();
                 for(Application__c a : trigger.new)
                  insertApplicationNew.put(a.Id,a);
             
             ClassApplicationHandler ahandler = new ClassApplicationHandler(  insertApplicationNew , null);
             // link contacts, projects to the application
             ahandler.linkContactidApplication();
             }
        }
        
   	    if (Trigger.isDelete) {
     
        }
        
    }
    
    }  
}