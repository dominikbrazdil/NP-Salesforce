/**
 * Schedulable job for Adapterra import
 */
global class SchedulableAdapterraImport implements Schedulable {
    
    global void execute(SchedulableContext sc) {
        System.enqueueJob(new AdapterraImportJob(Date.today().addDays(-1), Date.today().addDays(-1)));
    }
}
