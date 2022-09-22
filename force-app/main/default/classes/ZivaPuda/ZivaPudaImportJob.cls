public class ZivaPudaImportJob implements Queueable, Database.AllowsCallouts {
    private Date fromDate, toDate;


    public ZivaPudaImportJob(Date fromDate, Date toDate) {
        this.fromDate = fromDate;
        this.toDate = toDate;
    }

    public void execute(QueueableContext context) {
        Logger.init(context.getJobId());
        ZivaPudaLoader.loadContracts(fromDate, toDate);
        Logger.closeAndStore();
    }
}
