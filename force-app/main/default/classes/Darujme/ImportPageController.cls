/**
 * Controller of VF page for invoking data import manually
 */
public class ImportPageController {
    public Date fromDate {get;set;}
    public Date toDate {get;set;}

    public ImportPageController(ApexPages.StandardSetController ctrl) {
        // Can retrieve existing Dary in here
    }

    public PageReference runDonationsImport() {
        DarujmeImportJob job = new DarujmeImportJob(fromDate, toDate);
        Id jobId = System.enqueueJob(job);
        PageReference page = new PageReference('/lightning/o/Log__c/list');
        page.setRedirect(true);
        return page;
    }

    public PageReference runNominationsImport() {
        AdapterraImportJob job = new AdapterraImportJob(fromDate, toDate);
        Id jobId = System.enqueueJob(job);
        PageReference page = new PageReference('/lightning/o/Log__c/list');
        page.setRedirect(true);
        return page;
    }

    public PageReference runContractsImport() {
        ZivaPudaImportJob job = new ZivaPudaImportJob(fromDate, toDate);
        Id jobId = System.enqueueJob(job);
        PageReference page = new PageReference('/lightning/o/Log__c/list');
        page.setRedirect(true);
        return page;
    }
}
