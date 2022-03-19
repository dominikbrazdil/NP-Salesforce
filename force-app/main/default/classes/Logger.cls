public without sharing class Logger {

    private static Id executingJobID;
    private static List<Log__c> jobLogs;
    
    public static void init(Id jobID) {
        executingJobID = jobID;
        jobLogs = new List<Log__c>();
    }

    public static void log(LoggingLevel level, String msg) {
        System.debug(level, msg);
        DateTime now = DateTime.now();
        jobLogs.add(new Log__c(
            job_ID__c = executingJobID.to15(),
             Created_At__c = now,
             Timestamp__c = Time.newInstance(now.hour(), now.minute(), now.second(), now.millisecond()),
             Log_level__c = level.name(),
             Message__c = msg));
        
    }

    public static void log(String msg) {
        log(LoggingLevel.DEBUG, msg);
    }

    public static void closeAndStore() {
        Database.SaveResult[] srList = Database.insert(jobLogs,false);

        for (Integer i = 0; i < jobLogs.size(); i++) {
            if (!srList[i].isSuccess()) {
                System.debug(LoggingLevel.ERROR, 'Log could not be inserted: ' + srList[i].errors[0].getMessage());
            }
        }
    }
}
