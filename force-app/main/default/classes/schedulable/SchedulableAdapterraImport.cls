/**
 * Schedulable job for Adapterra import
 */
global class SchedulableAdapterraImport implements Schedulable {
    
    global void execute(SchedulableContext sc) {
        Integer delayInDays = 4;
        System.enqueueJob(new AdapterraImportJob(Date.today().addDays(delayInDays), Date.today().addDays(delayInDays)));
    }
}
