trigger MasterAgreementTrigger on Agreement__c  (before insert, after insert, before update, after update,  before delete, after delete) 
{ 
    // custom settings control
   if(TriggerControl__c.getValues('AgreementTrigger') != null)
   { 
    
   	 if (Trigger.isBefore) {
       Map <Id, Agreement__c > insertAgreementNew;
        
    	if (Trigger.isInsert) {
            if(TriggerControl__c.getValues('AgreementTriggerBeforeInsert') != null){ 
             insertAgreementNew = new Map<Id,Agreement__c>();
             for(Agreement__c a : trigger.new)
                insertAgreementNew.put(a.Id,a); 
                  
             ClassAgreementHandler bhandler = new ClassAgreementHandler(insertAgreementNew, Trigger.oldMap);
        } 
            
        }
   	    if (Trigger.isUpdate) {
           if(TriggerControl__c.getValues('AgreementTriggerBeforeUpdate') != null){ 
            ClassAgreementHandler bhandler = new ClassAgreementHandler(Trigger.newMap, Trigger.oldMap);
           }
        }
        if (Trigger.isDelete) { }
  	}

    if (Trigger.IsAfter) {
     
         
   	    if (Trigger.isUpdate) {
           if(TriggerControl__c.getValues('AgreementTriggerAfterUpdate') != null)
             { 
                 if(RecursionControl.firstRunAfter==true)
                 { 
                   RecursionControl.firstRunAfter=false;
                   ClassAgreementHandler ahandler = new ClassAgreementHandler(Trigger.newMap, Trigger.oldMap);
                   ahandler.linkContactidAgreement();  
                   
                 }
             }
            
   
        }
       	     

        if (Trigger.isInsert) { 
         if(TriggerControl__c.getValues('AgreementTriggerAfterInsert') != null){ 
                
               Map <Id, Agreement__c> insertAgreementNew;
                 insertAgreementNew = new Map<Id,Agreement__c>();
                 for(Agreement__c a : trigger.new)
                  insertAgreementNew.put(a.Id,a);
             
             ClassAgreementHandler ahandler = new ClassAgreementHandler(  insertAgreementNew , null);
             ahandler.linkContactidAgreement();
         }
        }
   	    if (Trigger.isDelete) {
     
        }
        
    }
    
    }  
}