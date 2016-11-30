// batch class to set the SDL lead status to PQL if they haven't been contacted for 15 days
// is activated by the time based trigger, evoked from the Pre Qualified Lead workflow on the Lead object

public with sharing class LeadActivityBatch2
    implements Database.Batchable<SObject>, Schedulable
{
    // for the test method
    public static String CRON_EXP = '0 0 0 3 9 ? 2022';
    
    @TestVisible static DateTime threshold =  Datetime.now().addDays(-15);
    @TestVisible static Date dtreshold =  date.newinstance(threshold.year(), threshold.month(), threshold.day());
    public static final String STATUS = 'Pre Qualified Lead';
    
    public Database.QueryLocator start(Database.BatchableContext context)
    { 
        return Database.getQueryLocator([
            SELECT Id FROM Lead WHERE Last_Activity_Date__c < :dtreshold  and Status ='Sales Development Lead'
        ]);
    }
    public void execute(Database.BatchableContext context, List<SObject> scope)
    {    
        for (SObject record : scope) record.put(Lead.Status, STATUS);
        update scope;
        
     
    }
    public  void finish(Database.BatchableContext context) { }

    public  void execute(SchedulableContext context)
    {  
        Database.executeBatch(this);
    }
}