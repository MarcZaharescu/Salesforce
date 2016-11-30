trigger MasterContactTrigger on Contact  (before insert, after insert, before update, after update,  before delete, after delete, after undelete) {
  
  // custom settings control
  if(TriggerControl__c.getValues('ContactTrigger') != null){
      
    if (Trigger.isBefore) {
       Map <Id, Contact> insertContactNew;
        
    	if (Trigger.isInsert) {
             if(TriggerControl__c.getValues('ContactTriggerBeforeInsert') != null){ 
                 
       	   insertContactNew = new Map<Id,Contact>();
            for(Contact c : trigger.new)
                insertContactNew.put(c.Id,c);
            
       	 ClassContactHandler bhandler = new ClassContactHandler(insertContactNew, Trigger.oldMap);
         //quality score for the contact
         bhandler.ContactQualityScore();  
         //contact email format  
         bhandler.Contact_Email_Format();
         // account email format
         bhandler.Account_Email_format();
             
             }               
        } 
   	    if (Trigger.isUpdate) {
              if(TriggerControl__c.getValues('ContactTriggerBeforeUpdate') != null){ 
        
         ClassContactHandler bhandler = new ClassContactHandler(Trigger.newMap, Trigger.oldMap);
         //quality score for the contact
         bhandler.ContactQualityScore(); 
         //contact email format  
         bhandler.Contact_Email_Format();
         // account email format
         bhandler.Account_Email_format();
         // update country based on the GA country
         bhandler.GaCountryToContact();
           
            }
   		 }
        if (Trigger.isDelete) { 
        }
        
        if (Trigger.isUndelete) {
        }
  	}

    if (Trigger.IsAfter) {
     
         
   	    if (Trigger.isUpdate) {
  		   if(TriggerControl__c.getValues('ContactTriggerAfterUpdate') != null){ 
               
          ClassContactHandler ahandler = new ClassContactHandler(Trigger.newMap, Trigger.oldMap);
          //contact count at the account level
          ahandler.ContactsAtAccount(); 
           }
        }
       	  if (Trigger.isInsert) {
              if(TriggerControl__c.getValues('ContactTriggerAfterInsert') != null){ 
                    
         ClassContactHandler ahandler = new ClassContactHandler(Trigger.newMap, Trigger.oldMap);
         //contact count at the account level
         ahandler.ContactsAtAccount();
              }
        }
        
   	    if (Trigger.isDelete) {
              if(TriggerControl__c.getValues('ContactTriggerAfterDelete') != null){ 
                  
         ClassContactHandler ahandler = new ClassContactHandler(Trigger.oldMap, Trigger.oldMap);
         //contact count at the account level
         ahandler.ContactsAtAccount();
         // account email format
         ahandler.Account_Email_format();
            
              }
        }
        
        if (Trigger.isUndelete) {
              if(TriggerControl__c.getValues('ContactTriggerAfterUnDelete') != null){ 
        
         ClassContactHandler ahandler = new ClassContactHandler(Trigger.newMap, Trigger.oldMap);
         //contact count at the account level
         ahandler.ContactsAtAccount();
         // account email format
         ahandler.Account_Email_format();
              }
     
          }
    
       }
    
    }  
 	 
}