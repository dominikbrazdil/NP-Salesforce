global class ScheduledDarujmeImport implements Schedulable {
    global void execute(SchedulableContext sc) {
        String todayDate = System.now().format('yyyy-MM-dd');
        System.enqueueJob(new DarujmeImportJob(todayDate, null));
    }
}