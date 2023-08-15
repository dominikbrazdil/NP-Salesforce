/**
 * Schedulable job for Darujme import
 */
global class SchedulableDarujmeImport implements Schedulable {
    global void execute(SchedulableContext sc) {
        System.enqueueJob(new DarujmeImportJob(Date.today().addDays(-1), null));
    }
}