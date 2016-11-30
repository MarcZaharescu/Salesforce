@isTest
public class LeadActivityBatch2_Test {
    
    public static testmethod void LeadTest()
    {
       Test.startTest();
         
         String query =' SELECT Id FROM Lead WHERE LastActivityDate < :dtreshold  and Status =  "Sales Development Lead"';
         Database.executeBatch(new LeadActivityBatch2(), 200);
 
         // Schedule the test job  
          String jobId = System.schedule('testLeadActivityBatch2ScheduledApex',
          LeadActivityBatch2.CRON_EXP, new LeadActivityBatch2());
         // Get the information from the CronTrigger API object 
          CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, nextFireTime FROM CronTrigger WHERE id = :jobId];

         // Verify the expressions are the same 
          System.assertEquals( LeadActivityBatch2.CRON_EXP, ct.CronExpression);

         // Verify the job has not run 
          System.assertEquals(0, ct.TimesTriggered);

         // Verify the next time the job will run 
          System.assertEquals('2022-09-03 00:00:00', 
          String.valueOf(ct.NextFireTime));
      
        Test.stopTest();
      
    }

}