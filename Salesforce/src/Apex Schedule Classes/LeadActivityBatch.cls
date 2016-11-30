// batch class to set the lead status to Return by Marketing
// is activated by the time based trigger, evoked from the Return to Marketing workflow on the Lead object

public with sharing class LeadActivityBatch
    implements Database.Batchable<SObject>, Schedulable
{
    // for the test method
    public static String CRON_EXP = '0 0 0 3 9 ? 2022';
    
    @TestVisible static DateTime threshold =  Datetime.now().addDays(-14);
    @TestVisible static Date dtreshold =  date.newinstance(threshold.year(), threshold.month(), threshold.day());
    public static final String STATUS = 'Return to Marketing';
    
    public Database.QueryLocator start(Database.BatchableContext context)
    {//system.debug('BatchActivityDate start');
        return Database.getQueryLocator([
            SELECT Id FROM Lead WHERE Last_Activity_Date__c < :dtreshold  and (Status ='Pre Qualified Lead' or Status = 'Qualified Lead')
        ]);
    }
    public void execute(Database.BatchableContext context, List<SObject> scope)
    {   // system.debug('BatchActivityDate - execute 2');
        for (SObject record : scope) record.put(Lead.Status, STATUS);
        update scope;
        //system.debug('BatchActivityDate - scope ' + scope);
     
    }
    public  void finish(Database.BatchableContext context) { }

    public  void execute(SchedulableContext context)
    {  // system.debug('BatchActivityDate - execute 1');
        Database.executeBatch(this);
    }
}