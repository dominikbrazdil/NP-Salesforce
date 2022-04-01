public class AdapterraImportJob implements Queueable, Database.AllowsCallouts {
    private Date fromDate, toDate;


    public AdapterraImportJob(Date fromDate, Date toDate) {
        this.fromDate = fromDate;
        this.toDate = toDate;
    }

    public void execute(QueueableContext context) {
        Logger.init(context.getJobId());
        AdapterraLoader.loadNominations(fromDate, toDate);
        Logger.closeAndStore();
    }
}
