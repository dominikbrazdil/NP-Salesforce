@isTest
public class TestUtils {

    public static Apex_config__c config = new Apex_config__c(
        Lead_amount_of_donations_limit__c = 2000,
        Lead_number_of_donations_limit__c = 5
    );

    public static List<Log__c> getErrorLogs(Id jobId) {
        return getLogs(jobId, LoggingLevel.ERROR);
    }

    public static List<Log__c> getLogs(Id jobId, LoggingLevel level) {
        return [SELECT Id, Log_level__c, Job_Id__c, Message__c FROM Log__c WHERE Job_Id__c = :jobID.to15() AND Log_level__c = :level.name()];
    }

    public static Object clone(Object obj, System.Type type) {
        return JSON.deserialize(JSON.serialize(obj), type);
    }

    public static List<Object> cloneToList(Object obj, System.Type type, Integer amount) {
        List<Object> objs = new List<Object>();
        for (Integer i = 0; i < amount; i++) {
            objs.add(JSON.deserialize(JSON.serialize(obj), type));
        }
        return objs;
    }
    
    public static DarujmeTransaction getTransaction(Integer promotionId) {

        DarujmeTransaction.Address address = new DarujmeTransaction.Address();
        address.street = 'Street1';
        address.city = 'City1';
        address.postCode = '000000';
        address.country = 'Country1';

        DarujmeTransaction.Donor donor = new DarujmeTransaction.Donor();
        donor.email = 'test1@gmail.com';
        donor.firstName = 'FirstName';
        donor.lastName = 'LastName';
        donor.phone = '777777777';
        donor.address = address;

        DarujmeTransaction.Amount amount = new DarujmeTransaction.Amount();
        amount.cents = 500000;
        amount.usedCurrency = DarujmeTransaction.CurrencyType.CZK;

        DarujmeTransaction.Pledge pledge = new DarujmeTransaction.Pledge();
        pledge.pledgedAmount = amount;
        pledge.pledgedAt = '2022-02-15T00:00:00+01:00';
        pledge.pledgeId = 2243747;
        pledge.organizationId = 1200442;
        pledge.projectId = 1202133;
        pledge.promotionId = promotionId;
        pledge.isRecurrent = true;
        pledge.donor = donor;
        pledge.wantDonationCertificate = true;

        DarujmeTransaction tr1 = new DarujmeTransaction();
        tr1.transactionId = 1111111;
        tr1.state = DarujmeTransaction.TransactionState.SENT_TO_ORGANIZATION;
        tr1.sentAmount = amount;
        tr1.outgoingAmount = amount;
        tr1.receivedAt = '2022-02-15T00:00:00+01:00';
        tr1.pledge = pledge;

        return tr1;
    }

    public static List<DarujmeTransaction> getClonedTransactions(Integer amount, Integer startingId) {
        List<DarujmeTransaction> trs = new List<DarujmeTransaction>();

        for (Integer i = 0; i < amount; i++) {
            DarujmeTransaction tr = getTransaction(getPromotion().promotionId);
            tr.transactionId = startingId + i;
            trs.add(tr);
        }
        return trs;
    }

    public static List<DarujmeTransaction> getClonedTransactions(DarujmeTransaction tr, Integer amount, Integer startingId) {
        List<DarujmeTransaction> trs = new List<DarujmeTransaction>();

        for (Integer i = 0; i < amount; i++) {
            DarujmeTransaction cloned = (DarujmeTransaction)clone(tr, DarujmeTransaction.class);
            cloned.transactionId = startingId + i;
            trs.add(cloned);
        }
        return trs;
    }

    public static DarujmePromotion getPromotion() {
        DarujmePromotion.BilingualText text = new DarujmePromotion.BilingualText();
        text.cs = 'Promotion title';

        DarujmePromotion pr1 = new DarujmePromotion();
        pr1.promotionId = 1111111;
        pr1.projectId = 1202133;
        pr1.title = text;

        return pr1;
    }
}
