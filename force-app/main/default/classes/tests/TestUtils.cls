@isTest
public class TestUtils {

    public static Apex_config__c initializeConfig() {
        Campaign bigDonorsCampaign = new Campaign(Name = 'bigDonors');
        Campaign mediumDonorsCampaign = new Campaign(Name = 'mediumDonors');
        Campaign smallDonorsCampaign = new Campaign(Name = 'smallDonors');
        Campaign recurrentDonorsCampaign = new Campaign(Name = 'recurrentDonors');
        insert new List<Campaign>{bigDonorsCampaign, mediumDonorsCampaign, smallDonorsCampaign, recurrentDonorsCampaign};

        Apex_config__c config = new Apex_config__c(
            Large_donors_campaign_id__c = bigDonorsCampaign.Id,
            Medium_donors_campaign_id__c = mediumDonorsCampaign.Id,
            Small_donors_campaign_id__c = smallDonorsCampaign.Id,
            Recurrent_donors_campaign_id__c = recurrentDonorsCampaign.Id,
            Large_donor_amount_of_donations_limit__c = 5000,
            Medium_donor_amount_of_donations_limit__c = 2000,
            Adapterra_Program_ID__c = 1
        );

        insert config;
        return config;
    }

    public static List<Log__c> getErrorLogs(Id jobId) {
        return getLogs(jobId, LoggingLevel.ERROR);
    }

    public static List<Log__c> getLogs(Id jobId, LoggingLevel level) {
        return [SELECT Id, Log_level__c, Job_Id__c, Message__c FROM Log__c WHERE Job_Id__c = :jobID.to15() AND Log_level__c = :level.name()];
    }
    
    public static DarujmeTransaction getTransaction(Integer promotionId) {

        DarujmeTransaction.Address address = new DarujmeTransaction.Address();
        address.street = 'Street1';
        address.city = 'City1';
        address.postCode = '000000';
        address.country = 'Country1';

        DarujmeTransaction.Donor donor = new DarujmeTransaction.Donor();
        donor.email = 'test1@gmail.com';
        donor.firstName = 'Pepa';
        donor.lastName = 'zDepa';
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

    public static Nomination getNomination() {
        Nomination.Category category = new Nomination.Category();
        category.id = '1';
        category.name = 'testCategory';

        Nomination.ContactPerson contactPerson = new Nomination.ContactPerson();
        contactPerson.fullName = 'Jaja Paja';
        contactPerson.firstName = 'Jaja';
        contactPerson.lastName = 'Paja';
        contactPerson.email = 'jajaapaja@nevim.com';
        contactPerson.phone = '123456789';

        Nomination.NominationContact contact = new Nomination.NominationContact();
        contact.organization = 'org234';
        contact.contaktPerson = contactPerson;

        Nomination nomination = new Nomination();
        nomination.id = 123;
        nomination.name = 'Nominace Darwinovy ceny';
        nomination.category = category;
        nomination.location = 'Planeta Zeme';
        nomination.gps = '123Z456S';
        nomination.description = 'This nomination is for the most stupid people risking their lives';
        nomination.category = category;
        nomination.web = 'seznam.cz';
        nomination.kraj = 'Vysocina';
        nomination.created = 'Now';
        nomination.contact = contact;

        return nomination;
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


    public static ZivaPudaContract getContract() {
        ZivaPudaContract.Ground ground1 = new ZivaPudaContract.Ground();
        ground1.parcelID = '1';
        ground1.type = 'Orná půda';
        ground1.uzemi = 'Ground 1';
        ground1.area = '100';

        ZivaPudaContract.Ground ground2 = new ZivaPudaContract.Ground();
        ground2.parcelID = '2';
        ground2.type = 'Les';
        ground2.uzemi = 'Ground 2';
        ground2.area = '100';
        
        ZivaPudaContract.Resignation resignation = new ZivaPudaContract.Resignation();
        resignation.articles = '6 a 7';
        resignation.lessee = '13mesicni';
        resignation.owner = '1mesicni';
        resignation.ownerElse = 'kdykoliv';

        ZivaPudaContract.MeasuresByGround measuresBG = new ZivaPudaContract.MeasuresByGround();
        measuresBG.measures = new List<String>{
            'agrolesnictví',
            'biopásy',
            'neposečení části louky',
            'výsadba stromů a keřů do polí (stromořadí, remízky)'
        };

        ZivaPudaContract.MandatoryMeasures measures = new ZivaPudaContract.MandatoryMeasures();
        measures.measuresByGrounds = new List<ZivaPudaContract.MeasuresByGround>{measuresBG, measuresBG};
        measures.type = 'konkrétní';

        ZivaPudaContract.Obligation obligation = new ZivaPudaContract.Obligation();
        obligation.pledge = new List<String>{'pledge1', 'pledge2'};
        obligation.mandatoryMeasures = measures;

        ZivaPudaContract.LeasePeriod period = new ZivaPudaContract.LeasePeriod();
        period.howLong = 10;
        period.noticePeriod = 12;
        period.type = 'Na dobu určitou';

        ZivaPudaContract.Owner owner = new ZivaPudaContract.Owner();
        owner.address = 'owner address';
        owner.birthdate = '1997-12-13';
        owner.name = 'Janko Stary';

        ZivaPudaContract.Lessee lessee = new ZivaPudaContract.Lessee();
        lessee.headquarters = 'Lessee Address';
        lessee.ICO = '987897987';
        lessee.name = 'Jozka Kozka';

        ZivaPudaContract contract = new ZivaPudaContract();
        contract.email = 'zivapuda@mail.com';
        contract.id = 1;
        contract.rent = 500.5;
        contract.sanctions = true;
        contract.signingDate = '24.06.2022 14:48:47';
        contract.url = 'https://p.propudu.cz/Specialni/Pachtovni-smlouva/1656073491925';
        contract.grounds = new List<ZivaPudaContract.Ground>{ground1, ground2};
        contract.leasePeriod = period;
        contract.lessee = lessee;
        contract.owners = new List<ZivaPudaContract.Owner>{owner, owner};
        contract.obligations = obligation;
        contract.resignation = resignation;

        return contract;
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

    public static List<Nomination> getClonedNominations(Integer amount, Integer startingId) {
        List<Nomination> noms = new List<Nomination>();

        for (Integer i = 0; i < amount; i++) {
            Nomination cloned = getNomination();
            cloned.id = startingId + i;
            noms.add(cloned);
        }
        return noms;
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


}