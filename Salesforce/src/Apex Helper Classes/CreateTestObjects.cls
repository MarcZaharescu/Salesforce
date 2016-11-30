public class CreateTestObjects {
    
    public List<lead> CreateLeads(Integer numberofleads,String name, Account a){  
        List<Lead> results = new List<Lead>();
       
        for(Integer i= 0;i< numberofleads; i++){
            
            Lead l = (Lead)Lead.SObjectType.newSObject(null,true);
            l.firstname= name+ String.valueOf(i);
            l.lastname= name+ String.valueOf(i);
            l.email=name+'@gmail.com';
            l.company= a.name;
            l.Status='Pre Qualified Lead';
            l.phone='0312312';
            l.mobilephone='123123123';
            l.Salutation='Mr.';
            l.Title='CEO';
           l.Account__c=a.id;
            results.add(l);
        }
        
        return results;
    }
    
    public List<Account> CreateAccounts(Integer numberofaccounts,String name){  
        List<Account> results = new List<Account>();
        for(Integer i= 0;i< numberofaccounts; i++){
            Account acc = (Account)Account.SObjectType.newSObject(null,true);
            acc.name= name+ String.valueOf(i);
   		    results.add(acc);
        }
        return results;
    }
    
    public List<Contact> CreateContacts(Integer numberofcontacts,String name, Account a){  
        List<Contact> results = new List<Contact>();
        for(Integer i= 0;i< numberofcontacts; i++){
            Contact con = (Contact)Contact.SObjectType.newSObject(null,true);
            con.firstname= name+ String.valueOf(i);
            con.lastname= 'test' +String.valueOf(i);
            con.salutation='Mr.'; 
  
            if(math.mod(i,6)==0)
            con.email=con.firstname+'.'+con.lastname+'@gmail.com';
            if(math.mod(i,6)==1)
            con.email=con.lastname+'.'+con.firstname+'@gmail.com';
            if(math.mod(i,6)==2)
            con.email=con.firstname +con.lastname+'@gmail.com';
            if(math.mod(i,6)==3)
            con.email=con.lastname+con.firstname+'@gmail.com';
            if(math.mod(i,6)==4)
            con.email=con.firstname.substring(0,1)+'.'+con.lastname+'@gmail.com';
            if(math.mod(i,6)==5)
            con.email=con.firstname.substring(0,1) +con.lastname+'@gmail.com';
            
            con.Accountid=a.id;
            con.phone='0245654567';
            con.MobilePhone='024567890';
            con.title='CEO';
            con.MBACOID__c=String.valueOf(i);
   		    results.add(con);
        }
        
        return results;
    }
    
    
        public List<Opportunity> CreateOpportunities(Integer numberofopportunities,String name, Account a,Contact c, String stagename){  
            List<opportunity> results = new List<Opportunity>();  
            for(Integer i= 0;i< numberofopportunities; i++){
                Opportunity o= (Opportunity)Opportunity.SObjectType.newSObject(null,true);
                Date closedate = Date.valueOf('2026-01-28');
                o.name=name+ String.valueOf(i);
                o.Accountid=a.id;
                o.Client_Contact__c=c.id;
                o.StageName=stagename;
                o.closedate=closedate;
                o.MBACOID__c=String.valueOf(i);
                results.add(o);
            }
            
        return results;
        }
    
     public List<Task> CreateTasks(Integer numberofTasks,String name,Contact c, Lead l){  
         List<Task> results = new List<Task>();
            for(Integer i= 0;i< numberoftasks; i++){
                Task t= (Task)Task.SObjectType.newSObject(null,true);
                Date dt = Date.valueOf('2016-01-28');
                t.Subject='Test';
                t.Send_Notification_Email__c=False; 
                if(i==0)
                t.Send_Notification_Email__c=True;  
                
                t.Email_List__C='marc.zaharescu@mbaco.com';
                t.ActivityDate=dt;
                
                if(Math.mod(i,2)==0)
                t.whoID=c.id; 
                if(Math.mod(i,2)==1)
                t.whoID=l.id;
                
                  results.add(t);
            }
         
         return results;
     }
    
      public List<Event> CreateEvents(Integer numberofEvents,String name, Contact c , Lead l){  
            List<Event> results = new List<Event>();
            for(Integer i= 0;i< numberofevents; i++){
                Event e= (Event)Event.SObjectType.newSObject(null,true);
                Date dt = Date.valueOf('2016-01-28');
                e.Subject='Test';
                e.Send_Notification_Email__c=False; 
                if(i==0)
                e.Send_Notification_Email__c=True;
                
                e.Email_List__C='marc.zaharescu@mbaco.com';
                e.ActivityDateTime=dt;
                e.DurationInMinutes=20;
                
                if(c!=null)
                e.whoID=c.id;
                if(l!=null)
                e.whoID=l.id;
                
                results.add(e);
            }
         
         return results;
     }
    
          public List<Application__c> CreateApplications(Integer numberofapplications,String name, List<Contact> contacts , List<Opportunity> opportunities) 
      {
          List<application__c> results = new List<Application__c>();
          for(Integer i= 0;i< numberofapplications; i++){
                Application__c a= ( Application__c) Application__c.SObjectType.newSObject(null,true);
                a.name= name+ String.valueOf(i);  
                a.Contactid__c =contacts[i].MBACOID__c;
                a.OpportunityId__c =opportunities[i].MBACOID__c;
                a.Application_id__c = String.valueof(i);
              results.add(a);
          }
          
          return results;
      }
    
      public List<Agreement__c> CreateAgreements(Integer numberofagreements,String name, List<Contact> contacts ,List<application__c> applications, List<Opportunity> opportunities) 
      {
          List<Agreement__c> results = new List<Agreement__c>();
          for(Integer i= 0;i< numberofagreements; i++){
                Agreement__c a= ( Agreement__c) Agreement__c.SObjectType.newSObject(null,true);
                a.name= name+ String.valueOf(i);  
                a.Contact_id__c =contacts[i].MBACOID__c;
                a.Project_Id__c =opportunities[i].MBACOID__c;
                a.Application_id__c=applications[i].application_id__c;
              
              results.add(a);
          }
          
          return results;
      }
}