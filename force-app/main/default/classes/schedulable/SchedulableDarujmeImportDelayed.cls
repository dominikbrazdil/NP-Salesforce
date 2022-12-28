/**
 * Schedulable job for Darujme import
 */
global class SchedulableDarujmeImportDelayed implements Schedulable {
    global void execute(SchedulableContext sc) {
        String filterLogMessage = 'DUPLICATE_VALUE';
        Integer delayInDays = 4;

        System.enqueueJob(new DarujmeImportJob(Date.today().addDays(-delayInDays), Date.today().addDays(-delayInDays), new List<String>{filterLogMessage}));
    }
}
