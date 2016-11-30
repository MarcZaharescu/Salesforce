trigger MasterAccountTrigger on Account  (before insert, after insert, before update, after update,  before delete, after delete) {
  
  // custom settings control
  if(TriggerControl__c.getValues('AccountTrigger') != null){
      
    if (Trigger.isBefore) {
       Map <Id, Account> insertAccountNew;
        
    	if (Trigger.isInsert) {
            if(TriggerControl__c.getValues('AccountTriggerBeforeInsert') != null){ 
                
          insertAccountNew = new Map<Id,Account>();
            for(Account a : trigger.new)
                insertAccountNew.put(a.Id,a); 
                  
            ClassAccountHandler bhandler = new ClassAccountHandler(insertAccountNew, Trigger.oldMap);
            // Account Quality Score
            bhandler.AccountQualityScore();
            
            // new Account insert -> duplciate check -> override missing information
            bhandler.newAccountDuplicateCheck();
            
          } 
 
        } 
   	    if (Trigger.isUpdate) {
            if(TriggerControl__c.getValues('AccountTriggerBeforeUpdate') != null){ 
         
            ClassAccountHandler bhandler = new ClassAccountHandler(Trigger.newMap, Trigger.oldMap); 
            // Account Quality Score
            bhandler.AccountQualityScore();
            }
              
   		 }
        if (Trigger.isDelete) { }
  	}

    if (Trigger.IsAfter) {
     
         
   	    if (Trigger.isUpdate) {
   
        }
       	  if (Trigger.isInsert) {
              
        }
        
   	    if (Trigger.isDelete) {
     
        }
       
      }
           
    }  
 	 
}