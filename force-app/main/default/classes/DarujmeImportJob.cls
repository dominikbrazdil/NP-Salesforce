public class DarujmeImportJob implements Queueable, Database.AllowsCallouts {
    private String fromDate, toDate;


    public DarujmeImportJob(String fromDate, String toDate) {
        this.fromDate = fromDate;
        this.toDate = toDate;
    }

    public void execute(QueueableContext context) {
        Logger.init(context.getJobId());
        DarujmeLoader.loadTransactions(fromDate, toDate);
        Logger.closeAndStore();
    }
}
