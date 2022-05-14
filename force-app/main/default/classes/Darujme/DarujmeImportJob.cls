/**
 * Queable asynchronous job for importing data from Darujme.cz
 */
public class DarujmeImportJob implements Queueable, Database.AllowsCallouts {
    private Date fromDate, toDate;


    public DarujmeImportJob(Date fromDate, Date toDate) {
        this.fromDate = fromDate;
        this.toDate = toDate;
    }

    public void execute(QueueableContext context) {
        Logger.init(context.getJobId());
        DarujmeLoader.loadTransactions(fromDate, toDate);
        Logger.closeAndStore();
    }
}
