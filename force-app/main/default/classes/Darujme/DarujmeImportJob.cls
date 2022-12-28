/**
 * Queable asynchronous job for importing data from Darujme.cz
 */
public class DarujmeImportJob implements Queueable, Database.AllowsCallouts {
    private Date fromDate, toDate;
    private List<String> logsToFilter;


    public DarujmeImportJob(Date fromDate, Date toDate) {
        this.fromDate = fromDate;
        this.toDate = toDate;
    }

    public DarujmeImportJob(Date fromDate, Date toDate, List<String> logsToFilter) {
        this.fromDate = fromDate;
        this.toDate = toDate;
        this.logsToFilter = logsToFilter;
    }

    public void execute(QueueableContext context) {
        Logger.init(context.getJobId());
        DarujmeLoader.loadTransactions(fromDate, toDate);
        Logger.closeAndStore(logsToFilter);
    }
}
