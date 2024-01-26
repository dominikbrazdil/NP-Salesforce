global class SchedulableZivaPudaImport implements Schedulable {
    
    global void execute(SchedulableContext sc) {
        System.enqueueJob(new ZivaPudaImportJob(Date.today().addDays(-1), Date.today().addDays(-1)));
    }
}