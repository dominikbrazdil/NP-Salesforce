public class ImportPageController {
    public Date fromDate {get;set;}
    public Date toDate {get;set;}

    public ImportPageController(ApexPages.StandardSetController ctrl) {
        // Can retrieve existing Dary in here
    }

    public PageReference runImport() {
        DarujmeImportJob job = new DarujmeImportJob(
            ((DateTime)fromDate).format('yyyy-MM-dd'), 
            ((toDate != null) ? ((DateTime)toDate).format('yyyy-MM-dd'): null));
        Id jobId = System.enqueueJob(job);
        PageReference page = new PageReference('/lightning/o/Log__c/list');
        page.setRedirect(true);
        return page;
    }
}
