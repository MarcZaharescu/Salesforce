public class ClassOpportunityHandler {
    
    Map<ID,Opportunity> newOpportunities;  
    Map<ID,Opportunity> oldOpportunities;  
    
    
    public ClassOpportunityHandler(Map<ID,Opportunity> newTriggerOpportunities,Map<ID,Opportunity> oldTriggerOpportunities){
        newOpportunities=newTriggerOpportunities;
        oldOpportunities=oldTriggerOpportunities;
    }
    
      /* add a Product when Opportunity is Pending Payment
     * 
     * 
     * 
     * 
     * 
     * 
     * 
     * 
     */
  /*  
    public void addProductWhenStageIsPendingPayment() {
        
        Set<id> ids = new Set<Id>();
        Set<id> PBOids = new Set<Id>();
        List<Opportunity> opplist = new List<Opportunity>();
        for(Opportunity o : newOpportunities.values()){
            String oldStageName= null;
            if(o.stagename=='In Progress' && o.StageName != oldOpportunities.get(o.id).StageName )
            {ids.add(o.id);
             PBOids.add(o.PriceBook2Id);
            }
        }
        
        
        List<Opportunity> opps = [Select id, Start_Date__c, End_Date__c,Opportunity_Commission_Rate__c,Consultant__r.FirstName,Consultant__R.LastName,Consultant_Day_Rate__c,CurrencyIsoCode,PriceBook2id from Opportunity where id in: ids and  Start_Date__c!=null and  End_Date__c!=null];

        List<Product2> products = [Select id,name, CurrencyIsoCode from Product2 where isActive=true ];
        Id product1Id=NULL;
        id product2id=NULL;
       
        list<PriceBookEntry> priceBookList = [SELECT Id, Product2Id,Pricebook2Id, Product2.Id, Product2.Name FROM PriceBookEntry 
                                             WHERE  PriceBook2.isStandard=true and isActive=true   ];
        Id priceBook1Id=NULL;
        id priceBook2id=NULL;
		
        List<OpportunityLineItem> oppsline = new List<OpportunityLineItem>();
        system.debug('products' + products);
        for(Opportunity op : opps)  
        {
            // get the product ids
             for(Product2 p : products)
        	{  
           	 	if(p.name=='Consultancy Services' & p.CurrencyIsoCode==op.CurrencyIsoCode )
                product1Id=p.id;
           	 	if(p.name=='MBA & Co Commission' & 	p.CurrencyIsoCode==op.CurrencyIsoCode)
                product2Id=p.id;
                
       		 }
            
            // get the price book ids
            for(PriceBookEntry pbe : priceBookList)
            {
                if(pbe.Product2Id== product1Id  )
                {priceBook1id = pbe.id;     
                 system.debug('price ' +priceBook1id);
                 system.debug('product '+ product1Id);
                }
                if(pbe.Product2Id == product2Id )
                    priceBook2id = pbe.id;
            }
            
            // get number of months
            Date startDate = op.Start_Date__c;
            Date endDate = op.End_Date__c;
            Integer monthDiff = startDate.monthsBetween(endDate);
			monthDiff++;
            Integer daysDiff= startDate.daysBetween(endDate);
            daysDiff++;
            
            // number of business days  
            Date startDt = startDate;
            Date endDt= endDate;
            
            Integer i3=getBusinessDays(StartDate, EndDate);      
            Integer businessDays=i3;
            Integer businessMonths = businessDays/22;
            Integer currentQuantity=0;
            
            
 		    Decimal currentPrice=0;
            
            system.debug('business days' + businessdays);
            Date dateField=op.Start_Date__c;
            for(integer j=0; j<monthDiff ; j++)
            {
                // calculate invoice day
                
                Integer numberOfDays = Date.daysInMonth(dateField.year(), dateField.month());
				Date lastDayOfMonth = Date.newInstance(dateField.year(), dateField.month(), numberOfDays);
                
                //calcualte quantity
                businessMonths = monthDiff-j-1;
                if(businessMonths>0) 
                    currentQuantity =getBusinessDays( StartDate,lastDayOfMonth);
                else
                    currentQuantity =businessdays;
                
               System.debug('currentQuantity  : - '+currentQuantity );
               System.debug('bdays  : - '+businessdays);
             
                
                //calcualte totalprice
                 currentPrice=currentQuantity*op.Consultant_Day_Rate__c;
                
               // get consultant name
               String consultantName= op.Consultant__r.FirstName +' '+ op.Consultant__r.LastName;
                system.debug('priceBook1Id '  + priceBook1Id);
                system.debug('priceBook2Id ' + priceBook2Id);
                //create the product line items
                if(currentQuantity>0)
                { 
                	OpportunityLineItem oli1 = new OpportunityLineItem( PricebookEntryId=  priceBook1Id  , Opportunityid=op.id,TotalPrice=currentPrice,Quantity=currentQuantity ,ServiceDate=lastDayOfMonth, Description='Consultancy Services Provided by '+consultantName,Estimate_Actual__c='Estimated');
               	    OpportunityLineItem oli2 = new OpportunityLineItem( PricebookEntryId=  priceBook2Id , Opportunityid=op.id, TotalPrice=currentPrice/op.Opportunity_Commission_Rate__c,Quantity=currentQuantity ,ServiceDate=lastDayOfMonth,	Description='MBA Comission',Estimate_Actual__c='Estimated');
               	 	oppsline.add(oli1);
               	 	oppsline.add(oli2);
                }
                
                
                // increase date field with 1 month
                 datefield= datefield.addMonths(1);
                system.debug('dt field '+dateField);
                
                // recalculate business days
                businessDays-=currentQuantity;
                
              //  op.PriceBook2Id=null;
                opplist.add(op);
            }
            
        }
         // update opplist;
          insert oppsline;
 
    }
    
     // get business days method
          public Integer getBusinessDays( Date startdt, Date enddt)
            {
                
          
 			Date tempdate = null;
 		 	 if (startdt > enddt) {
 	      	tempdate = enddt;
 		  	enddt = startdt;
 		  	startdt = tempdate;
 			}
            
		Integer i = Math.mod((date.newinstance(1985, 6, 24)).daysBetween(startdt),7); // 24/6/85 was a monday
		Map<Integer, Map<Integer, Integer>> m = new Map<Integer, Map<Integer, Integer>> {
		0 => new Map<Integer, Integer> { 1 => 2 , 2 => 3 , 3 => 4 , 4 => 5 , 5 => 5 , 6 => 5 },
		1 => new Map<Integer, Integer> { 1 => 2 , 2 => 3 , 3 => 4 , 4 => 4 , 5 => 4 , 6 => 5 },
		2 => new Map<Integer, Integer> { 1 => 2 , 2 => 3 , 3 => 3 , 4 => 3 , 5 => 4 , 6 => 5 },
		3 => new Map<Integer, Integer> { 1 => 2 , 2 => 2 , 3 => 2 , 4 => 3 , 5 => 4 , 6 => 5 },
		4 => new Map<Integer, Integer> { 1 => 1 , 2 => 1 , 3 => 2 , 4 => 3 , 5 => 4 , 6 => 5 },
		5 => new Map<Integer, Integer> { 1 => 0 , 2 => 1 , 3 => 2 , 4 => 3 , 5 => 4 , 6 => 5 },	
		6 => new Map<Integer, Integer> { 1 => 1 , 2 => 2 , 3 => 3 , 4 => 4 , 5 => 5 , 6 => 5 }
		};
            
		Integer i2 = Math.mod((startdt.daysBetween(enddt)),7);	
		Integer i3 = (m.get(i)).get(i2);
		if (i2 == null || i2 < 1 || i2 > 6) {
		if (i >= 0 && i <= 4) { i3 = 1; } 
		else  { i3 = 0; }
		}
		i3 = i3 + 5 * (Math.floor( ((Decimal) startdt.daysBetween(enddt)).divide(7,4))).intValue(); 
		if (tempdate != null) i3 *= -1; // negative number of days
	   
            return i3;
          }
    */
    
    
    /* add Oppp to Campaign
     * 
     * 
     * 
     * 
     * 
     * 
     * 
     * 
     */
    
     public void addOpportunityToCampaign()   
     {
         Set<id> ids = new Set<id>();
        for(Opportunity opp :  newOpportunities.values()){
            if(opp.New_Repeat__c =='Repeat')
                ids.add(opp.id);
        }
         
         List<Opportunity> oppsToUpdate = [ Select id , Campaignid from opportunity where id in: ids];
         List<Campaign> campaigns = [Select id from Campaign where name='Inbound – Repeat'];
         for(Opportunity o : oppsToUpdate)
         {
             if(campaigns.size()>0)
             o.campaignid=campaigns[0].id;
         }
         
          update oppsToUpdate;

     }

      /*  change Opp Status depending on Sub Status
     *
     * 
     * 
     * 
     *  
     * 
     * 
     * 
     */
     public void changeOppStatus(){
       
         for(Opportunity opp :  newOpportunities.values()){
             
           if(opp.StageName=='Opportunity' || opp.StageName=='Hiring' || opp.StageName=='Interviewing' || opp.StageName=='Reviewing')
           {  
             if(opp.Project_Stage__c=='Platform matching' || opp.Project_Stage__c=='Sourcing' )
                 opp.StageName='Hiring';
             if(opp.Project_Stage__c=='Proposals submitted' || opp.Project_Stage__c=='Proposals internally reviewed'  || opp.Project_Stage__c=='Proposals sent to client'  || opp.Project_Stage__c=='Waiting for proposal feedback' )
                 opp.StageName='Reviewing';
             if(opp.Project_Stage__c=='1st interview being scheduled' || opp.Project_Stage__c=='1st interview scheduled'  || opp.Project_Stage__c=='Waiting for interview feedback'  || opp.Project_Stage__c=='Further interviews being scheduled' || opp.Project_Stage__c=='Further interviews scheduled' || opp.Project_Stage__c=='Waiting for client decision' )
                 opp.StageName='Interviewing';
           }  
             
            String a;
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
              a='test';
             
         }
     
     }
    
        /*  count Opportunities on Contact
     *
     * 
     * 
     * 
     *  
     * 
     * 
     * 
     */
     public void OppCountOnContact(){
         
    Set<id> contactIds = new Set<id>();
    List<Contact> lst_contact_open = new List<Contact>();
    List<Contact> lst_contact_closed = new List<Contact>();
    List<Contact> lst_contact_created = new List<Contact>();
    Set<Id> setIds = new Set<Id>();
    List<Opportunity> lst_opp = new List<Opportunity>();
    Map<ID, Integer> map_opp_open = new Map<ID, Integer>();
    Map<ID, Integer> map_opp_closed = new Map<ID,  Integer>();
    Map<ID,  Integer> map_opp_created = new Map<ID,  Integer>();
    
    Set<Contact> upd_con = new Set<Contact>();
    List<Contact> upd_con1 = new List<Contact>();
    List<Contact> upd_con2 = new List<Contact>();
     
    //List<Opportunity> lst_all_opp_triggered = Trigger.isDelete ? Trigger.old : Trigger.new;
 
    for(Opportunity opp :  newOpportunities.values())
    {	
        if(opp.Client_Contact__C!=null)
        contactIds.add(opp.Client_Contact__c);
        
    }
         
        
         
         AggregateResult[] opencounts = [SELECT  Client_contact__c ,count(id) open FROM Opportunity WHERE  (stagename = 'Opportunity' OR stagename='Hiring'   OR stagename='Reviewing' OR  stagename='Interviewing') and Client_contact__c IN :  contactIds GROUP BY  Client_contact__c ];   
		 AggregateResult[] woncounts = [SELECT  Client_contact__c ,count(id) won FROM Opportunity WHERE  (stagename = 'Pending Payment' OR stagename='Complete' OR stagename ='In Progress') and Client_contact__c IN :  contactIds GROUP BY  Client_contact__c ];    
	 	 AggregateResult[] createdcounts = [SELECT  Client_contact__c ,count(id) created FROM Opportunity WHERE   Client_contact__c IN :  contactIds GROUP BY  Client_contact__c ];    
		for(Integer i=0; i<opencounts.size();i++){
         map_opp_open.put(string.valueof(opencounts[0].get('Client_contact__c')),integer.valueof(opencounts[i].get('open'))) ;  
        }
         
         for(Integer i=0; i<woncounts.size();i++){
         map_opp_closed.put(string.valueof(woncounts[0].get('Client_contact__c')),integer.valueof(woncounts[i].get('won'))) ;  
        }
         
          for(Integer i=0; i<createdcounts.size();i++){
         map_opp_created.put(string.valueof(createdcounts[0].get('Client_contact__c')),integer.valueof(createdcounts[i].get('created'))) ;  
        }
     
         
         
	for(Integer i=0; i<createdcounts.size();i++){
        Integer openOpp=0;
        Integer wonOpp=0;
        Integer createdOpp =0;
        if(opencounts.size()>i )
            if(map_opp_open.get(string.valueof(opencounts[i].get('Client_contact__c')))!=null)
       		    openOpp=map_opp_open.get(string.valueof(opencounts[i].get('Client_contact__c')));
        
         if(woncounts.size()>i )
       		  if(map_opp_closed.get(string.valueof(woncounts[i].get('Client_contact__c')))!=null)
       		    wonOpp=map_opp_closed.get(string.valueof(woncounts[i].get('Client_contact__c')));
        
         if(createdcounts.size()>i )
        	  if(map_opp_created.get(string.valueof(createdcounts[i].get('Client_contact__c')))!=null)
       		    createdOpp=map_opp_created.get(string.valueof(createdcounts[i].get('Client_contact__c')));
        
		Contact tempContact = new Contact(Id=string.valueof(createdcounts[0].get('Client_contact__c')),Open_Opp_Count__c=openOpp, Closed_Opp_Count__c = wonOpp, Created_Opp_count__c=createdOpp);
		if(!setids.contains(tempContact.id))
        { 
           setids.add(tempContact.id);
           upd_con1.add(tempContact);
        }
	}
 
         
	 update upd_con1;

     }
      /*  Update Close Date on Opportunity
     * 
     * 
     * 
     * 
     * 
     * 
     * 
     * 
     * 
	*/
    public void setSalesManager()
    {
       Map<String,id  > managerList = new Map<String,id>();
        List<User> managerusers = new List<User>([Select id, name from User]);
        for(User u: managerusers){
            managerList.put(u.name,u.id );       
        }
        
          for(Opportunity o: newOpportunities.values())
        {
         
            if(o.Delivery_Owner__c!=null)
            { 
              if(managerList.get(o.Delivery_Owner__c)!=null)
              {
                 o.ownerid=managerList.get(o.Delivery_Owner__c);
              }         
             }
            
          
        }
        
    }
    
    /*  Update Close Date on Opportunity
     * 
     * 
     * 
     * 
     * 
     * 
     * 
     * 
     * 
	*/
    public void updateOpportunityCloseDate(){
        
        
        for(Opportunity o: newOpportunities.values())
        {
            if(o.CloseDate<Date.today() && o.IsClosed==false && (o.StageName!='Complete' || o.StageName!='Lost' || o.StageName!='Rejected' ||  o.StageName!='In Progress' || o.StageName!='Pending Payment'))
            {
           
                o.CloseDate=Date.Today()+7;
            }
        }
        
    }
    
    /*        Rapid Miner Fields update
     * 
     * 
     *     - method depreciated -
     * 
     * 
     * 
     * 
     * 
     * 
     **/
    /*public void RapidMinerFields() {
        
        Map<id,Integer> oppMap = new Map<id,Integer>();
        Map<id,Integer> oppWonMap = new Map<id,Integer>();
        Map<id,Integer> oppClientDuration = new Map<id,Integer>();
        Map<id,DateTime> opplastProjectCreated = new Map<id,DateTime>();
        Map<id,Integer> oppAverageGP = new Map<id,Integer>();
        
        Set<id> accid = new Set<id>();
        for(Opportunity o : newOpportunities.values() )
        {
             if(o.Accountid!=null)
             { 	oppMap.put(o.id,1); accid.add(o.Accountid);
       		 }
        }
        
      List<Account> accountsWithOpportunities= [select id, name, (select id,CreatedDate,StageName,  convertCurrency(GP__c)  from Opportunities order by CreatedDate)
                                                                from Account where Id IN : accid];     
        
   
 			DateTime newdate=DateTime.newInstance(1900, 1, 1, 1, 1, 1);

         for(Account a :  accountsWithOpportunities)
         {       
           
                for(Opportunity o1 : a.Opportunities){
                       
                    
                    DateTime minDate=a.Opportunities[0].createdDate;
                    DateTime maxdate= DateTime.newInstance(1900, 1, 1, 1, 1, 1); 
                    
                    oppMap.put(o1.id,0); 
                    oppWonMap.put(o1.id,0);
                    oppClientDuration.put(o1.id,0);
                    oppLastProjectCreated.put(o1.id,newDate);
                    oppAverageGp.put(o1.id,0);
                    Integer sum=0;
                    Integer count=0;
                      for(Opportunity o2 : a.Opportunities){ 	
                      
                       
                          if(o1.CreatedDate>o2.CreatedDate){ 
                               
                              
                                // for last project created
                                  if(maxDate<o2.CreatedDate) {
                                      maxDate=o2.CreatedDate;
                                  }
                              
                              
 								//for average project value
 								 sum = sum + (Integer)o2.GP__C;
                                 Count = count+1;
                              
                               
                                //for created opportunities
                                if(oppMap.get(o1.id)!=null){ 
                                   Integer i = (Integer)oppMap.get(o1.id);
                  			       oppMap.put(o1.id, (i+1));
                                }  
                               
                          		 //for won opportunities
                          		 if(oppWonMap.get(o1.id)!=null){ 
                                     if(o2.StageName=='Pending Payment' || o2.StageName=='Complete' || o2.StageName=='In Progress')
                                     { 
                                       Integer i1 = (Integer)oppWonMap.get(o1.id);
                  			           oppWonMap.put(o1.id, (i1+1));
                                     }
                                     
                                 }
                              
                            }  
                          
                      }
                    
                      // for client duration
                        if(oppClientDuration.get(o1.id)==0){ 
                                    
                          Integer duration = (date.Valueof(minDate)).daysBetween(date.ValueOf(o1.CreatedDate));
                          if(duration<0)
                           duration=0;
                            
                          oppClientDuration.put(o1.id,duration);
                                    
                       }
                    
                     //for last project created
                      if(opplastProjectCreated.get(o1.id)!=null){ 
                          opplastProjectCreated.put(o1.id,maxDate);                            
                      }
                      
                     //for average gp
                       if(oppAverageGP.get(o1.id)!=null){ 
                           Integer average=0;
                           if(o1.GP__c!=null)
                           sum=sum+(Integer)o1.GP__c;
                           count=count+1;
                           if(sum>0 && count>0)
                             average = (sum)/(count);
                           oppAverageGP.put(o1.id,average);
                          
                          
                       }
                    
                    
                    
                }    
         }
        
         Map<id,Integer>  oppContacts = new Map<id,integer>();
         List<Account> accountsWithContacts = [Select id, (Select id,CreatedDate from Contacts) , (select id,CreatedDate from Opportunities) from Account where id =: accid];
         for(Account a :  accountsWithContacts)
         {       
              
             for(Opportunity o : a.Opportunities)
              { 
                   oppContacts.put(o.id,0);
                  
                 for(Contact c :a.Contacts){
                       
                     
                      if(C.createdDate<o.CreatedDate)
                      {
                          if(oppContacts.get(o.id)!=null)
                          { 
                          Integer i= oppContacts.get(o.id);
                          oppContacts.put(o.id,(i+1));
                          }
                      }
                  }   
             }
         }
        
         for(Opportunity o : newOpportunities.values()) {
              
             if(oppMap.get(o.id)!=null)
             o.RapidMiner_Opportunities_Created__c=oppMap.get(o.id);
             if(oppWonMap.get(o.id)!=null)
             o.RapidMiner_Opportunities_Closed__c=oppWonMap.get(o.id);
             if(oppClientDuration.get(o.id)!=null)
             o.RapidMiner_Client_Duration__c=oppClientDuration.get(o.id);
             if(opplastProjectCreated.get(o.id)!=null)  
             o.RapidMiner_Last_Project_Created__c=Date.ValueOf(opplastProjectCreated.get(o.id));
             if(oppContacts.get(o.id)!=null)
             o.RapidMiner_Contacts_at_Account__c=oppCOntacts.get(o.id);
             if( oppAverageGP.get(o.id)!=null)
             o.RapidMiner_AverageGp__c=oppAverageGP.get(o.id);
    
    
         }
        
    }
    */
    
   
    /*  count Tasks and Events on Opportunities
     *
     * 
     * 
     * 
     *  
     * 
     * 
     * 
     */
     

    public void CountActivitiesOnOpportunities()
    {		
         Set<id> contactIds = new Set<id>();
         Set<id> opportunityIds = new Set<id>();
        
         List<Opportunity> opps = new List<Opportunity>();
         List<Contact> contacts = new List<Contact>();
         List<Task> tasks = new List<Task>();
         List<Event> events = new List<Event>();
        
         Map<id,Integer> mapAllTasks = new Map<id,Integer>();
         Map<id,Integer> mapAllEvents = new Map<id,Integer>();
         Map<id,Integer> mapCallTasks = new Map<id,Integer>();
         Map<id,Integer> mapCallEvents = new Map<id,Integer>();
         Map<id,Integer> mapEmailTasks = new Map<id,Integer>();
         Map<id,Integer> mapEmailEvents= new Map<id,Integer>();
         Map<id,Integer> mapMeetingEvents= new Map<id,Integer>(); 
         Map<id,Integer> mapMeetingTasks= new Map<id,Integer>(); 
         Map<id,List<Task>> mapTaskContact = new Map<id,List<Task>>();
         Map<id,List<Event>> mapEventContact = new Map<id,List<Event>>();
   
         Map<Contact,List<Opportunity>> mapOppContact = new Map<Contact,List<Opportunity>>();
        		 
    	 String callsubject='call';
   		 String emailsubject='Email%';
   		 String meetingsubject='Meeting%';          
    	 String calltype='Call';
    	 String emailtype='Email';
   	     String meetingtype='Meeting';
        
          for(Opportunity o: newOpportunities.values()) {
    
            if(o.Client_Contact__C!=null){  
                   contactIds.add(o.Client_Contact__c);
             }
          }
        
                  tasks= [Select id,subject,CreatedDate,whoid from Task where WhoId in:contactIds];
                  events= [Select id,type,CreatedDate,whoid from Event where WhoId in:contactIds]; 
      
        		//create a task map with the contact and related tasks
         
				for(Task t: tasks)
                {    
                     
                    if(!mapTaskContact.containsKey(t.WhoId)){
                        
                       List<Task> temp = new List<Task>();
                       temp.add(t);
                       mapTaskContact.put(t.WhoId, temp);
                    }
                    
                    else{ 
                       mapTaskContact.get(t.WhoId).add(t);
                     }

                 }
             //create an event map with the contact and related events
            
				for(Event e: events)
                {    
                     
                    if(!mapEventContact.containsKey(e.WhoId)){
                        
                       List<Event> temp = new List<Event>();
                       temp.add(e);
                       mapEventContact.put(e.WhoId, temp);
                    }
                    
                    else{
                       mapEventContact.get(e.WhoId).add(e);
                     }

                 }

        for(Opportunity o: newOpportunities.values()) {  
            if(o.Client_Contact__C!=null ){     
               if(mapTaskContact.size()>0) { 
                  if(mapTaskContact.get(o.Client_Contact__c)!=null) { 
                      
                    for(Task t : mapTaskContact.get(o.Client_Contact__c)){
                  
                    //tasks
                    if(mapAllTasks.get(t.whoID)==null) {
                        if( (date.newinstance(o.CreatedDate.Year(),o.CreatedDate.Month(),o.CreatedDate.Day())<= date.newinstance(t.CreatedDate.Year(),t.CreatedDate.Month(),t.CreatedDate.Day())) && o.CloseDate>=t.CreatedDate){  
                       	    mapAllTasks.put(t.whoId,1);
                              
                           if((t.subject.indexOf('Call')!= -1 || t.subject.indexOf('call')!= -1) &&((t.subject.indexOf('Email')== -1 && t.subject.indexOf('email')== -1))  ) 
                                mapCallTasks.put(t.whoid,1);
                            
                             if((t.subject.indexOf('Email')!= -1 || t.subject.indexOf('email')!= -1) && (t.subject.indexOf('Act-On')==-1 &&  t.subject.indexOf('Act On')==-1)   )   
                                mapEmailTasks.put(t.whoid,1);
                            
                            if((t.subject.indexOf('meeting')!= -1 || t.subject.indexOf('Meeting')!= -1) && (t.subject.indexOf('Email')== -1 && t.subject.indexOf('email')== -1))   
                                mapMeetingTasks.put(t.whoid,1);
                            
                        }
                    }
                    else{ 
                         if((date.newinstance(o.CreatedDate.Year(),o.CreatedDate.Month(),o.CreatedDate.Day())<= date.newinstance(t.CreatedDate.Year(),t.CreatedDate.Month(),t.CreatedDate.Day()))&& o.CloseDate>=t.CreatedDate) { 
                       		    Integer i= mapAllTasks.get(t.whoId);
                       		    mapAllTasks.put(t.whoID,(i+1));
                        
                                
                            if((t.subject.indexOf('Call')!= -1 || t.subject.indexOf('call')!= -1) &&((t.subject.indexOf('Email')== -1 && t.subject.indexOf('email')== -1))  ){  
                                Integer i1;
                                if(mapCallTasks.get(t.whoId)!=null) 
                                    i1= mapCallTasks.get(t.whoId);
                                  else
                                    i1=0;
                                mapCallTasks.put(t.whoid,(i1+1));
                            }
                             
                             if((t.subject.indexOf('meeting')!= -1 || t.subject.indexOf('Meeting')!= -1) && (t.subject.indexOf('Email')== -1 && t.subject.indexOf('email')== -1)  )  {  
              
                                Integer i1;
                                if(mapMeetingTasks.get(t.whoId)!=null) 
                                    i1= mapMeetingTasks.get(t.whoId);
                                  else
                                    i1=0;
                                mapMeetingTasks.put(t.whoid,(i1+1));
                            }   
                            
                             
                              
                             if((t.subject.indexOf('Email')!= -1 || t.subject.indexOf('email')!= -1) && (t.subject.indexOf('Act-On')==-1 &&  t.subject.indexOf('Act On')==-1) )   {  
                                Integer i2;
                                if(mapEmailTasks.get(t.whoId)!=null) 
                                    i2= mapEmailTasks.get(t.whoId);
                                  else
                                    i2=0;
                               mapEmailTasks.put(t.whoid,(i2+1));
                            }
                         }
                    }
                }
                  
                  }
                    //Events
          	if(mapEventContact.size()>0){   
                if(mapEventContact.get(o.Client_Contact__c)!=null){ 
                for(Event e : mapEventContact.get(o.Client_Contact__c)){
                   
                    if(mapAllEvents.get(e.whoID)==null) {
                        if((date.newinstance(o.CreatedDate.Year(),o.CreatedDate.Month(),o.CreatedDate.Day())<= date.newinstance(e.CreatedDate.Year(),e.CreatedDate.Month(),e.CreatedDate.Day())) && o.CloseDate>=e.CreatedDate){  
                       	    mapAllEvents.put(e.whoId,1);
                              
                            if(e.type=='Call')
                                mapCallEvents.put(e.whoid,1);
                            
                             if(e.type=='Email')   
                                mapEmailEvents.put(e.whoid,1);
                            
                             if(e.type=='Meeting')   
                                mapMeetingEvents.put(e.whoid,1);
                             
                        }
                    }
                    else{ 
                         if((date.newinstance(o.CreatedDate.Year(),o.CreatedDate.Month(),o.CreatedDate.Day())<= date.newinstance(e.CreatedDate.Year(),e.CreatedDate.Month(),e.CreatedDate.Day()))  && o.CloseDate>=e.CreatedDate) { 
                       		    Integer i= mapAllEvents.get(e.whoId);
                       		    mapAllEvents.put(e.whoID,(i+1));
                             
                                
                            if(e.type=='Call'){  
                                Integer i1;
                                if(mapCallEvents.get(e.whoId)!=null) 
                                    i1= mapCallEvents.get(e.whoId);
                                  else
                                    i1=0;
                                mapCallEvents.put(e.whoid,(i1+1));
                            }
                             
                            if(e.type=='Email'){  
                                Integer i2;
                                if(mapEmailEvents.get(e.whoId)!=null) 
                                    i2= mapEmailEvents.get(e.whoId);
                                  else
                                    i2=0;
                               mapEmailEvents.put(e.whoid,(i2+1));
                            }
                             
                            if(e.type=='Meeting'){  
                               Integer i3;
                               if(mapMeetingEvents.get(e.whoId)!=null) 
                                    i3= mapMeetingEvents.get(e.whoId);
                                  else
                                    i3=0;
                               mapMeetingEvents.put(e.whoid,(i3+1));
                            }
                         }   
                      
                     }
                    
                 }
               }
             }
           }
                
                if(mapAllTasks.get(o.Client_Contact__c)>0)
                o.Total_Activities__c=mapAllTasks.get(o.Client_Contact__c);
                   else
                o.Total_Activities__c=0;        
			    if(mapAllEvents.get(o.Client_Contact__c)>0) 
                o.Total_Activities__c+=mapAllEvents.get(o.Client_Contact__c);
                    
                if(mapCallTasks.get(o.Client_Contact__c)>0)
                o.Total_Calls__c=mapCallTasks.get(o.Client_Contact__c);
                   else
                o.Total_Calls__c= 0;         
				if(mapCallEvents.get(o.Client_Contact__c)>0)
                o.Total_Calls__c+=mapCallEvents.get(o.Client_Contact__c);
                    
                if(mapEmailTasks.get(o.Client_Contact__c)>0)
                o.Total_Emails__c=mapEmailTasks.get(o.Client_Contact__c);
                   else
                o.Total_Emails__c=0;       
                if(mapEmailEvents.get(o.Client_Contact__c)>0)
                o.Total_Emails__c+=mapEmailEvents.get(o.Client_Contact__c);
                    
 				if(mapMeetingEvents.get(o.Client_Contact__c)>0) 
                o.Total_Meetings__c=mapMeetingEvents.get(o.Client_Contact__c);
                else
                 o.Total_Meetings__c=0;
                
                if(mapMeetingTasks.get(o.Client_Contact__c)>0) 
                o.Total_Meetings__c+=mapMeetingTasks.get(o.Client_Contact__c); 
                
            }      
        }
    }	        
             
    
    
}