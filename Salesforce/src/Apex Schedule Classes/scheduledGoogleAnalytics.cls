global class scheduledGoogleAnalytics implements Schedulable {
   global void execute(SchedulableContext SC) {
      retrieveGAdata.main();
   }
}