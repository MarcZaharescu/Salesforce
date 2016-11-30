trigger MasterOpportunityTrigger on Opportunity  (before insert, after insert, before update , after update,  before delete, after delete,after undelete) {
  
  // custom settings control
  if(TriggerControl__c.getValues('OpportunityTrigger') != null){
      
    if (Trigger.isBefore) {
       Map <Id, Opportunity> insertOpportunityNew;
        
    	if (Trigger.isInsert) {
             if(TriggerControl__c.getValues('OpportunityTriggerBeforeInsert') != null){ 
                 
           insertOpportunityNew = new Map<Id, Opportunity>();
            for(Opportunity o : trigger.new)
                insertOpportunityNew.put(o.Id, o); 
           
          ClassOpportunityHandler bhandler = new ClassOpportunityHandler( insertOpportunityNew, Trigger.oldMap);  
          // 
          //  - Method Depreciated -
          // 
          // rapid miner update trigger 
          // 
          // bhandler.RapidMinerFields();
          //set the sales manager
          bhandler.setSalesManager();
          // change opportunity status based on project sub status
          bhandler.changeOppStatus();
          }
        } 
        
   	    if (Trigger.isUpdate) {
            if(TriggerControl__c.getValues('OpportunityTriggerBeforeUpdate') != null){ 
            
        ClassOpportunityHandler bhandler = new ClassOpportunityHandler(Trigger.newMap, Trigger.oldMap);
        // count the activities on opportunities based on related contact
        bhandler.CountActivitiesOnOpportunities();
        // rapid miner update trigger (only on insert event for now)
        // bhandler.RapidMinerFields();
        // update closed date
        bhandler.updateOpportunityCloseDate();
        // set the sales manager
        bhandler.setSalesManager();
        // change opportunity status based on project sub status
        bhandler.changeOppStatus();
            }
   		 }
        
        if (Trigger.isDelete) { }
  	}

    if (Trigger.IsAfter) {
       
   	    if (Trigger.isUpdate) {
               if(TriggerControl__c.getValues('OpportunityTriggerAfterUpdate') != null){ 
         
         ClassOpportunityHandler ahandler = new ClassOpportunityHandler(Trigger.newMap, Trigger.oldMap);
		 ahandler.OppCountOnContact();
            
         //   ---- functionality temporary removed ----
         //   
         //   if(TriggerControl__c.getValues('OpportunityProductCreation') != null)
         //   add products to related opportunities if the opportunity stage is in Progress
         //   ahandler.addProductWhenStageIsPendingPayment(); 
         
         }
       }
       	  if (Trigger.isInsert) {
               if(TriggerControl__c.getValues('OpportunityTriggerAfterInsert') != null){ 
              
          ClassOpportunityHandler ahandler = new ClassOpportunityHandler(Trigger.newMap, null);
          ahandler.OppCountOnContact();
          // add opportunity to Repeat Campaign if it is a repeat opportunity
          ahandler.addOpportunityToCampaign();     
        
          }
        }
        
   	    if (Trigger.isDelete) {
             if(TriggerControl__c.getValues('OpportunityTriggerAfterDelete') != null){ 
            
           ClassOpportunityHandler ahandler = new ClassOpportunityHandler(Trigger.oldMap, Trigger.oldMap);
           ahandler.OppCountOnContact();      
          }
        }
        
        if (Trigger.isUndelete) {
            if(TriggerControl__c.getValues('OpportunityTriggerAfterUnDelete') != null){ 
            
          ClassOpportunityHandler ahandler = new ClassOpportunityHandler(Trigger.newMap, Trigger.oldMap);
          ahandler.OppCountOnContact();      
          }
        }
      }
    }
 }