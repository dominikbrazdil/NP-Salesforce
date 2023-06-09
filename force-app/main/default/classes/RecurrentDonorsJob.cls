/**
 * Queable asynchronous job for checking recurrent donors
 */
public class RecurrentDonorsJob implements Queueable {

    public void execute(QueueableContext context) {
        Logger.init(context.getJobId());
        Logger.log('Starting to look for lost and renewed recurrent donors');
        markLostRecurrentDonorsAndRenewRestoredOnes();
        Logger.log('Looking for lost and renewed recurrent donors finished');
        Logger.closeAndStore();
    }
    
    /**
     * Checks if all recurrent donors sent a recurring donations in a last month and marks those who did not
     */
    public static void markLostRecurrentDonorsAndRenewRestoredOnes() {
        Date monthAgo = Date.today().addDays(-40);
        List<Contact> recurrentDonors = [SELECT Id, Pravidelny_darce__c, Ztraceny_pravidelny_darce__c, Email, (SELECT Id, Datum__c, Pravidelny_dar__c FROM Dary__r WHERE Datum__c >= :monthAgo) FROM Contact WHERE Pravidelny_darce__c = true];

        List<Contact> lostDonors = new List<Contact>();
        List<Contact> renewedDonors = new List<Contact>();

        for (Contact donor: recurrentDonors) {
            Boolean paidInLastMonth = false;
            for (Dar__c dar: donor.Dary__r) {
                if (dar.Pravidelny_dar__c) {
                    paidInLastMonth = true;
                    break;
                }
            }

            if (!paidInLastMonth) {
                donor.Pravidelny_darce__c = false;
                donor.Ztraceny_pravidelny_darce__c = true;
                Logger.log(LoggingLevel.WARN, 'Recurrent donor ' + donor.Email + ' did not sent a recurrent donation last month');
                lostDonors.add(donor);
            }

            if (paidInLastMonth && donor.Ztraceny_pravidelny_darce__c) {
                donor.Pravidelny_darce__c = true;
                donor.Ztraceny_pravidelny_darce__c = false;
                Logger.log(LoggingLevel.INFO, 'Lost recurrent donor ' + donor.Email + ' is renewed after incoming recurrent donation');
                renewedDonors.add(donor);
            }
        }

        update lostDonors;
        update renewedDonors;
    }

}
