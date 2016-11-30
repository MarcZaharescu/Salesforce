public class dataListCon {

 

    public String getUsername() {
       
      List<User> username = new List<User>([Select user.name from user where id=:userID]);
        return username[0].name;
    }


   
//------------------------------------Sort Direction and Get The Selected Column Methods------------------------------------------

    private String sortDirection = 'ASC';
    private String sortExp = 'Name';
    private String userValue1=UserInfo.getUserID();
    private ID userId;
    public void setUserValue1(String value){
    this.userValue1=value;
    }
    public String getUserValue1( ){
    return this.userValue1;
    }
      
    
   public String sortExpression
   {
     get
     {
        return sortExp;
     }
     set
     {
       //if the column is clicked on then switch between Ascending and Descending modes
       if (value == sortExp)
         sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
       else
         sortDirection = 'ASC';
       sortExp = value;
     }
   }

 public String getSortDirection()
 {
    //if not column is selected 
    if (sortExpression == null || sortExpression == '')
      return 'ASC';
    else
     return sortDirection;
 }

    
    
    
 public void setSortDirection(String value)
 {  
   sortDirection = value;
 }
  


// ---------------------------View Data Methods for Sorting The Columns----------------------------------------

   public PageReference ViewDataAccountsT1() {
        
        String userID= userValue1;
        String Other='Other';
        String Prospect='Prospect';
        String High='High Value';
        String Loyal='Loyal';
        string sortFullExp = sortExpression  + ' ' + sortDirection;
        String Tier1='High Potential';
        String One='One Time';
      
        accountsT1 = Database.query('SELECT Account.Active_L12M__c, Account.Revenue_To_Date__c,Account.Opportunity_Win_Ratio__c,Account.ownerID,Account.name,owner.firstname, owner.lastname,Account.Opportunities_Created__c , Account.OpportunitiesClosed__c,Account.Average_opportunity_Value__c,Account.Client_Value__c FROM Account' 
        +' WHERE Account.ownerID=:userID  AND Account.Account_Priority__c=:Tier1 AND (Account.Client_Value__C =:One OR Account.Client_Value__C =:Other OR Account.Client_Value__C =:Prospect OR Account.Client_Value__C =:Loyal OR Account.Client_Value__C =:High ) order by ' + sortFullExp);
      
       return null;
   }
   
    public PageReference ViewDataAccountsT2() {
        
        String userID= userValue1;
        String Other='Other';
        String Prospect='Prospect';
        String High='High Value';
        String Loyal='Loyal';
        string sortFullExp = sortExpression  + ' ' + sortDirection;
        String Tier2='Medium Potential';
        String One='One Time';
      
        accountsT2 = Database.query('SELECT Account.Active_L12M__c, Account.Revenue_To_Date__c,Account.Opportunity_Win_Ratio__c,Account.ownerID,Account.name,owner.firstname, owner.lastname,Account.Opportunities_Created__c , Account.OpportunitiesClosed__c,Account.Average_opportunity_Value__c,Account.Client_Value__c FROM Account' 
        +' WHERE Account.ownerID=:userID  AND Account.Account_Priority__c=:Tier2 AND (Account.Client_Value__C =:One OR Account.Client_Value__C =:Other OR Account.Client_Value__C =:Prospect OR Account.Client_Value__C =:Loyal OR Account.Client_Value__C =:High ) order by ' + sortFullExp);
      
       return null;
   }

   public PageReference ViewDataContacts() {
        
        String userID= userValue1;
        String sortFullExp = sortExpression  + ' ' + sortDirection;
      
        contacts = Database.query('Select id,Contacted_30_days__c,Name,Account.name,Office_Location__c,Phone,Email,Created_opp_count__c,Closed_Opp_Count__c,User_Win_Ratio__c FROM Contact where OwnerId=:userID order by ' +sortFullExp);
 		totalSizeContacts =  contacts.size();
        ContactsToShow.clear();
           if((counterCC+limitSize) <= totalSizeContacts){
            for(Integer i=0;i<limitSize;i++){
                ContactsToShow.add( Contacts.get(i));
                
            }
        }else{
            for(Integer i=0;i<totalSizeContacts;i++){
               ContactsToShow.add( Contacts.get(i));            
            }          
        }
   
       
       
       return null;

   }


   public PageReference ViewDataOpenOpportunities() {
        
       String userID= userValue1;
       String sortFullExp = sortExpression  + ' ' + sortDirection;
       String falseEx='false';
      
        openOpportunities = Database.query('SELECT  Opportunity.Delivery_Specialist__c , Opportunity.Days_Open__c , Opportunity.Weighted_Probability__c , Opportunity.NextStep,  Opportunity.Opportunity_Commission_Rate__c ,  Opportunity.MBA_Co_Commission__c , Opportunity.Health__c, Opportunity.CreatedDate,Opportunity.ID,Opportunity.name,owner.firstname, owner.lastname,Opportunity.StageName,Opportunity.Gross_Profit__c,Opportunity.CloseDate,Opportunity.Forecast_Judgment__c FROM Opportunity WHERE Opportunity.OwnerId=:userID AND Opportunity.ISCLOSED=false ORDER BY ' +sortFullExp);
    
       
        totalSizeOpenOpportunities =  openOpportunities.size();
        OpportunitiesToShow.clear();
        if((counterOO+limitSize) <= totalSizeOpenOpportunities){
            for(Integer i=0;i<limitSize;i++){
                OpportunitiesToShow.add( openOpportunities.get(i));
               
            }
        }else{
            for(Integer i=0;i<totalSizeOpenOpportunities;i++){
                OpportunitiesToShow.add( openOpportunities.get(i));
                
            }
            
        }
 
        
       
       return null;
   }


   public PageReference ViewDataClosedOpportunities() {
        
       String userID= userValue1;
       String sortFullExp = sortExpression  + ' ' + sortDirection;
       String trueEx='true';
      
       closedOpportunities = Database.query('SELECT Opportunity.Delivery_Specialist__c , Opportunity.Days_Open__c , Opportunity.Weighted_Probability__c , Opportunity.NextStep,  Opportunity.Opportunity_Commission_Rate__c ,  Opportunity.MBA_Co_Commission__c , Opportunity.Health__c, Opportunity.CreatedDate,Opportunity.ID,Opportunity.name,owner.firstname, owner.lastname,Opportunity.StageName,Opportunity.Gross_Profit__c,Opportunity.CloseDate,Opportunity.Forecast_Judgment__c FROM Opportunity  WHERE Opportunity.OwnerId=:userID AND Opportunity.ISCLOSED=true  ORDER BY ' +sortFullExp);
       totalSizeClosedOpportunities =  closedOpportunities.size();
       ClosedOpportunitiesToShow.clear();   
       if((counterCO+limitSize) <= totalSizeClosedOpportunities){
            for(Integer i=0;i<limitSize;i++){
                ClosedOpportunitiesToShow.add( closedOpportunities.get(i));
                
            }
        }else{
            for(Integer i=0;i<totalSizeClosedOpportunities;i++){
                ClosedOpportunitiesToShow.add( closedOpportunities.get(i));            
            }          
        }
       
       return null;
   }


// ---------------------------------------------Change User Picklist Methods----------------------------------------------------------


    public List<Account> userListValue {get;set;}
    public id userValue {get;set;}    
    public void setUserValue(String value){
        this.userValue=value;
    }
    public List<SelectOption> regionOptions {get;set;}
    
    
    public List<SelectOption> getUserOptions() {
    List<SelectOption> userOptions = new List<SelectOption>();
        
        List<User> userlist= [Select user.firstname, user.lastname from User where UserRole.Name='UK Sales' OR UserRole.Name='US Sales' OR UserRole.Name='CEO' OR UserRole.Name='Ambassador' OR UserRole.Name='Head of Sales'   OR UserRole.Name='Germany Sales' OR UserRole.Name='Asia Sales' ORDER BY user.lastname ASC];
        
        userOptions.add(new SelectOption(UserInfo.getUserID(),UserInfo.getfirstname() +' '+ UserInfo.getlastname()));
        
         for(User u :userlist) {
                 useroptions.add(new selectoption(u.id, u.firstname +' '+ u.lastname));
                               }
        return userOptions;
        }    
    
    
//------------------------------------------Update The Selected List----------------------------------------------------------
    
    public void updateUserValue() {
    
      userValue1=userValue;
      userID= userValue;
    
 
      List<Account>  L1= new List<Account>([SELECT Account.Active_L12M__c, Account.Revenue_To_Date__c,Account.Opportunity_Win_Ratio__c,Account.ownerID,Account.name,owner.firstname, owner.lastname,Account.Opportunities_Created__c , Account.OpportunitiesClosed__c,Account.Average_opportunity_Value__c,Account.Client_Value__c FROM Account
      WHERE Account.OwnerId=:userID AND Account.Account_Priority__c='High Potential' AND (Account.Client_Value__c='Other' OR Account.Client_Value__c='Prospect' OR Account.Client_Value__c='High Value' OR Account.Client_Value__c='Loyal'  OR Account.Client_Value__c='One time') Order By Account.Revenue_To_Date__c DESC]);   
      accountsT1=  new List<Account>();
      accountsT1.addALL(L1);
      
       List<Account>  L2= new List<Account>([SELECT Account.Active_L12M__c, Account.Revenue_To_Date__c,Account.Opportunity_Win_Ratio__c,Account.ownerID,Account.name,owner.firstname, owner.lastname,Account.Opportunities_Created__c , Account.OpportunitiesClosed__c,Account.Average_opportunity_Value__c,Account.Client_Value__c FROM Account
      WHERE Account.OwnerId=:userID AND Account.Account_Priority__c='Medium Potential' AND (Account.Client_Value__c='Other' OR Account.Client_Value__c='Prospect' OR Account.Client_Value__c='High Value' OR Account.Client_Value__c='Loyal'  OR Account.Client_Value__c='One time') Order By Account.Revenue_To_Date__c DESC]);   
      accountsT2=  new List<Account>();
      accountsT2.addALL(L2);
     
      userListValue =accountsT1;
      
      List<Opportunity> OO1= new List<Opportunity>([SELECT  Opportunity.Delivery_Specialist__c , Opportunity.Days_Open__c , Opportunity.Weighted_Probability__c , Opportunity.NextStep,  Opportunity.Opportunity_Commission_Rate__c ,  Opportunity.MBA_Co_Commission__c , Opportunity.Health__c
      ,Opportunity.CreatedDate,Opportunity.ID,Opportunity.name,owner.firstname, owner.lastname,Opportunity.StageName,Opportunity.Gross_Profit__c,Opportunity.CloseDate,Opportunity.Forecast_Judgment__c FROM Opportunity
      WHERE Opportunity.OwnerId=:userValue AND Opportunity.ISCLOSED=false ORDER BY Opportunity.CloseDate ASC ]); 
      openOpportunities=  new List<Opportunity>();
      openOpportunities.addALL(OO1);
     
      List<Opportunity> CO1= new List<Opportunity>([SELECT 
      Opportunity.Delivery_Specialist__c , Opportunity.Days_Open__c , Opportunity.Weighted_Probability__c , Opportunity.NextStep,  Opportunity.Opportunity_Commission_Rate__c ,  Opportunity.MBA_Co_Commission__c , Opportunity.Health__c,
      Opportunity.CreatedDate,Opportunity.ID,Opportunity.name,owner.firstname, owner.lastname,Opportunity.StageName,Opportunity.Gross_Profit__c,Opportunity.CloseDate,Opportunity.Forecast_Judgment__c FROM Opportunity
      WHERE Opportunity.OwnerId=:userValue AND Opportunity.ISCLOSED=true  ORDER BY Opportunity.CloseDate DESC]); 
      closedOpportunities=  new List<Opportunity>();
      closedOpportunities.addALL(CO1);
             
      List<Contact> contactlist= new List<Contact>([Select id,Contacted_30_days__c,Name,Account.name,Office_Location__c,Phone,Email,Created_opp_count__c,Closed_Opp_Count__c,User_Win_Ratio__c FROM Contact where OwnerId=:userValue order by Closed_Opp_Count__c DESC]);
      contacts=new List<Contact>();
      contacts.addALL(contactList);
        
         
          	
        OpportunitiesToShow = new list<Opportunity>();
        ContactsToShow =new list<Contact>();
        ClosedOpportunitiesToShow=new list<Opportunity>();
        //Get all the contacts which are from Public realations lead source
      
        //Store the total size
        totalSizeOpenOpportunities =   openOpportunities.size();
        totalSizeClosedOpportunities =   closedOpportunities.size();
        totalSizeContacts =   Contacts.size();
        
        //Intial adding of contacts to ContactsToShow
        //check the total records are more than limitSize and assign the records
        if((counterOO+limitSize) <= totalSizeOpenOpportunities){
            for(Integer i=0;i<limitSize;i++){
                OpportunitiesToShow.add( openOpportunities.get(i));
                
            }
        }else{
            for(Integer i=0;i<totalSizeOpenOpportunities;i++){
                OpportunitiesToShow.add( openOpportunities.get(i));            
            }          
        }
        
        
        
        
           if((counterCO+limitSize) <= totalSizeClosedOpportunities){
            for(Integer i=0;i<limitSize;i++){
                ClosedOpportunitiesToShow.add( closedOpportunities.get(i));
                
            }
        }else{
            for(Integer i=0;i<totalSizeClosedOpportunities;i++){
                ClosedOpportunitiesToShow.add( closedOpportunities.get(i));            
            }          
        }
        
        
           if((counterCC+limitSize) <= totalSizeContacts){
            for(Integer i=0;i<limitSize;i++){
                ContactsToShow.add( Contacts.get(i));
                
            }
        }else{
            for(Integer i=0;i<totalSizeContacts;i++){
               ContactsToShow.add( Contacts.get(i));            
            }          
        }
      
    }


   
 

//-----------------------------------------Get and Set Methods---------------------------------------------------------


    public list<Opportunity> closedOpportunities {get; set;}
   
    public list<Opportunity> getclosedOpportunities() {  
        return closedOpportunities;
    }

    

    public list<Opportunity> getopenOpportunities() {  
        return openOpportunities;
    }
     public list<Opportunity> openOpportunities {get; set;}
  
 

   
     public List<Account> accountsT2 { get; set; }

     public List<Account> accountsT1 { get; set; }
     
     public list<Contact> contacts{get; set;}
     
     public list<Contact> getContact(){
     return contacts;
     }

//------------------------------------------------The Constructor------------------------------------------------------------------

    public dataListCon() {
    
       userID= UserInfo.getUserID();
       String sortFullExp = sortExpression  + ' ' + sortDirection;
       String Other='Other';
       String Prospect='Prospect';
       String High='High Value';
       String One='One Time';
       String Loyal='Loyal';
       String trueEx='true';
       String falseEx='false';
       String Tier1='High Potential';
       String Tier2='Medium Potential';
      
    
     accountsT1 = Database.query('SELECT Account.Active_L12M__c, Account.Revenue_To_Date__c,Account.Opportunity_Win_Ratio__c,Account.ownerID,Account.name,owner.firstname, owner.lastname,Account.Opportunities_Created__c , Account.OpportunitiesClosed__c,Account.Average_opportunity_Value__c,Account.Client_Value__c FROM Account' 
      +' WHERE Account.ownerID=:userID AND Account.Account_Priority__c=:Tier1 AND (Account.Client_Value__C =:One OR Account.Client_Value__C =:Other OR Account.Client_Value__C =:Prospect OR Account.Client_Value__C =:Loyal OR Account.Client_Value__C =:High ) order by ' +sortFullExp);    
     
      accountsT2 = Database.query('SELECT Account.Active_L12M__c, Account.Revenue_To_Date__c,Account.Opportunity_Win_Ratio__c,Account.ownerID,Account.name,owner.firstname, owner.lastname,Account.Opportunities_Created__c , Account.OpportunitiesClosed__c,Account.Average_opportunity_Value__c,Account.Client_Value__c FROM Account' 
      +' WHERE Account.ownerID=:userID AND Account.Account_Priority__c=:Tier2 AND (Account.Client_Value__C =:One OR Account.Client_Value__C =:Other OR Account.Client_Value__C =:Prospect OR Account.Client_Value__C =:Loyal OR Account.Client_Value__C =:High ) order by ' +sortFullExp);    
     
     
     contacts = Database.query('Select id,Contacted_30_days__c,Name,Account.name,Office_Location__c,Phone,Email,Created_opp_count__c,Closed_Opp_Count__c,User_Win_Ratio__c FROM Contact where OwnerId=:userID order by ' +sortFullExp);
    
     openOpportunities = Database.query('SELECT  Opportunity.Delivery_Specialist__c , Opportunity.Days_Open__c , Opportunity.Weighted_Probability__c , Opportunity.NextStep,  Opportunity.Opportunity_Commission_Rate__c ,  Opportunity.MBA_Co_Commission__c , Opportunity.Health__c, Opportunity.CreatedDate,Opportunity.ID,Opportunity.name,owner.firstname, owner.lastname,Opportunity.StageName,Opportunity.Gross_Profit__c,Opportunity.CloseDate,Opportunity.Forecast_Judgment__c FROM Opportunity WHERE Opportunity.OwnerId=:userID AND Opportunity.ISCLOSED=false ORDER BY ' +sortFullExp);
    
     closedOpportunities = Database.query('SELECT Opportunity.Delivery_Specialist__c , Opportunity.Days_Open__c , Opportunity.Weighted_Probability__c , Opportunity.NextStep,  Opportunity.Opportunity_Commission_Rate__c ,  Opportunity.MBA_Co_Commission__c , Opportunity.Health__c, Opportunity.CreatedDate,Opportunity.ID,Opportunity.name,owner.firstname, owner.lastname,Opportunity.StageName,Opportunity.Gross_Profit__c,Opportunity.CloseDate,Opportunity.Forecast_Judgment__c FROM Opportunity  WHERE Opportunity.OwnerId=:userID AND Opportunity.ISCLOSED=true  ORDER BY ' +sortFullExp);
    
  	// Pagination for Opportunities   
  	   
        limitSize=500;  	 	
        OpportunitiesToShow = new list<Opportunity>();
        ContactsToShow =new list<Contact>();
        ClosedOpportunitiesToShow=new list<Opportunity>();
        //Get all the contacts which are from Public realations lead source
      
        //Store the total size
        totalSizeOpenOpportunities =   openOpportunities.size();
        totalSizeClosedOpportunities =   closedOpportunities.size();
        totalSizeContacts =   Contacts.size();
        
        //Intial adding of contacts to ContactsToShow
        //check the total records are more than limitSize and assign the records
        if((counterOO+limitSize) <= totalSizeOpenOpportunities){
            for(Integer i=0;i<limitSize;i++){
                OpportunitiesToShow.add( openOpportunities.get(i));
                
            }
        }else{
            for(Integer i=0;i<totalSizeOpenOpportunities;i++){
                OpportunitiesToShow.add( openOpportunities.get(i));            
            }          
        }
        
        
        
        
           if((counterCO+limitSize) <= totalSizeClosedOpportunities){
            for(Integer i=0;i<limitSize;i++){
                ClosedOpportunitiesToShow.add( closedOpportunities.get(i));
                
            }
        }else{
            for(Integer i=0;i<totalSizeClosedOpportunities;i++){
                ClosedOpportunitiesToShow.add( closedOpportunities.get(i));            
            }          
        }
        
        
           if((counterCC+limitSize) <= totalSizeContacts){
            for(Integer i=0;i<limitSize;i++){
                ContactsToShow.add( Contacts.get(i));
                
            }
        }else{
            for(Integer i=0;i<totalSizeContacts;i++){
               ContactsToShow.add( Contacts.get(i));            
            }          
        }
    
        
      
    }
    
   //----------------------------------------------Pagination-------------------------------------------------------------------------------
    
            
 
    
    //List to show the limited records on the page
    public list<Opportunity> OpportunitiesToShow {get; set;}
    public list<Opportunity> ClosedOpportunitiesToShow {get; set;}
    public list<Contact> ContactsToShow {get; set;} 
    
    //Navigation variables
    Integer counterOO = 0;//TO track the number of records parsed
    Integer counterCO =0;
    Integer counterCC =0;
 
    Integer totalSizeOpenOpportunities =0; //To Store the total number of records available
    Integer totalSizeClosedOpportunities =0; //To Store the total number of records available
    Integer totalSizeContacts =0; //To Store the total number of records available
    Integer limitSize; 
    
    public void setLimitSize( Integer value)
    {this.limitSize=value;}
     
    
    //Navigation methods
    
    
	public void beginningOO(){
   
        OpportunitiesToShow.clear();
        counterOO=0;
        
        //open opps
        if((counterOO + limitSize) <= totalSizeOpenOpportunities){
       
            for(Integer i=0;i<limitSize;i++){
                OpportunitiesToShow.add( openOpportunities.get(i));
                
            }   
        }
    }
    
    public void beginningCO(){
   
        ClosedOpportunitiesToShow.clear();
        counterCO=0;
        
        //closed opps
         if((counterCO + limitSize) <= totalSizeClosedOpportunities){  
            for(Integer i=0;i<limitSize;i++){
                ClosedOpportunitiesToShow.add( closedOpportunities.get(i));
            }   
           
        } else{
       
            for(Integer i=0;i<totalSizeClosedOpportunities;i++){
                ClosedOpportunitiesToShow.add( closedOpportunities.get(i));   
            }       
           
        }
   
    }
   
    
    public void beginningCC(){
 
        ContactsToShow.clear();
        counterCC=0;

        // users
        
         if((counterCC + limitSize) <= totalSizeContacts){
       
            for(Integer i=0;i<limitSize;i++){
 
                ContactsToShow.add(contacts.get(i)); 
            }   
           
        } else{
       
            for(Integer i=0;i<totalSizeContacts;i++){
 
                ContactsToShow.add(contacts.get(i));
  
            }       
           
        }
             
    }
   
   
    public void nextCC(){
 
        ContactsToShow.clear();
        counterCC=counterCC+limitSize;
       
       
        // users
        
             if((counterCC+limitSize) <= totalSizeContacts){
            for(Integer i=counterCC-1;i<(counterCC+limitSize);i++){
                ContactsToShow.add( Contacts.get(i));
 
            }
        } else{
            for(Integer i=counterCC;i<totalSizeContacts;i++){
              ContactsToShow.add( contacts.get(i));
 
            }
        }
    }
    
     public void nextOO(){
   
        OpportunitiesToShow.clear(); 
        counterOO=counterOO+limitSize;
       
        // openOpps
        if((counterOO+limitSize) <= totalSizeOpenOpportunities){
            for(Integer i=counterOO-1;i<(counterOO+limitSize);i++){
                OpportunitiesToShow.add( openOpportunities.get(i));
 
            }
        } else{
            for(Integer i=counterOO;i<totalSizeOpenOpportunities;i++){
               OpportunitiesToShow.add( openOpportunities.get(i));
 
            }
        }
    
    }
    
     public void nextCO(){
         
        ClosedOpportunitiesToShow.clear();
        counterCO=counterCO+limitSize;
       
    
        // closed Opps
             if((counterCO+limitSize) <= totalSizeClosedOpportunities){
            for(Integer i=counterCO-1;i<(counterCO+limitSize);i++){
                ClosedOpportunitiesToShow.add( closedOpportunities.get(i));
 
            }
        } else{
            for(Integer i=counterCO;i<totalSizeClosedOpportunities;i++){
               ClosedOpportunitiesToShow.add( closedOpportunities.get(i));
 
            }
        }
    }
   
    public void previousOO(){
   
        OpportunitiesToShow.clear();
        counterOO=counterOO-limitSize;       
       
        for(Integer i=counterOO;i<(counterOO+limitSize); i++){
            OpportunitiesToShow.add( openOpportunities.get(i)); 
        }
    }
        public void previousCO(){
   
        ClosedOpportunitiesToShow.clear();
        counterCO=counterCO-limitSize;       
       
        for(Integer i=counterCO;i<(counterCO+limitSize); i++){
            ClosedOpportunitiesToShow.add( closedOpportunities.get(i)); 
        }
    }
        public void previousCC(){
   
        ContactsToShow.clear();
        counterCC=counterCC-limitSize;       
       
        for(Integer i=counterCC;i<(counterCC+limitSize); i++){
            ContactsToShow.add( contacts.get(i)); 
        }
    }
    
    

    public void lastOO (){
   
        OpportunitiesToShow.clear(); 
        if(math.mod(totalSizeOpenOpportunities , limitSize) == 0){
            counterOO = limitSize * ((totalSizeOpenOpportunities/limitSize)-1);
        } else if (math.mod(totalSizeOpenOpportunities , limitSize) != 0){
            counterOO = limitSize * ((totalSizeOpenOpportunities/limitSize));
        }
       
        for(Integer i=counterOO-1;i<totalSizeOpenOpportunities-1;i++){
                OpportunitiesToShow.add( openOpportunities.get(i));
        
        }
       
    }
    
        public void lastCO (){
   
        ClosedOpportunitiesToShow.clear(); 
        if(math.mod(totalSizeClosedOpportunities , limitSize) == 0){
            counterCO = limitSize * ((totalSizeClosedOpportunities/limitSize)-1);
        } else if (math.mod(totalSizeOpenOpportunities , limitSize) != 0){
            counterCO = limitSize * ((totalSizeClosedOpportunities/limitSize));
        }
       
        for(Integer i=counterCO-1;i<totalSizeClosedOpportunities-1;i++){
                ClosedOpportunitiesToShow.add( closedOpportunities.get(i));
        
        }
       
    }
    
        public void lastCC (){
   
        ContactsToShow.clear(); 
        if(math.mod(totalSizeContacts , limitSize) == 0){
            counterCC = limitSize * ((totalSizeContacts/limitSize)-1);
        } else if (math.mod(totalSizeContacts , limitSize) != 0){
            counterCC = limitSize * ((totalSizeContacts/limitSize));
        }
       
        for(Integer i=counterCC-1;i<totalSizeContacts-1;i++){
                ContactsToShow.add( Contacts.get(i));
        
        }
       
    }
   
    public Boolean getDisableNextOO(){
   
        if((counterOO + limitSize) >= totalSizeOpenOpportunities )
            return true ;
        else
            return false ;
    }
   
    public Boolean getDisablePreviousOO(){
   
        if(counterOO == 0)
            return true ;
        else
            return false ;
    }  
    
     public Boolean getDisableNextCO(){
   
        if((counterCO + limitSize) >= totalSizeClosedOpportunities )
            return true ;
        else
            return false ;
    }
   
    public Boolean getDisablePreviousCO(){
   
        if(counterCO == 0)
            return true ;
        else
            return false ;
    }  
    
     public Boolean getDisableNextCC(){
   
        if((counterCC + limitSize) >= totalSizeContacts )
            return true ;
        else
            return false ;
    }
   
    public Boolean getDisablePreviousCC(){
   
        if(counterCC == 0)
            return true ;
        else
            return false ;
    }  
    
 }