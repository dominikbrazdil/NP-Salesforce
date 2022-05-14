/**
 * Queable asynchronous job for checking recurrent donors
 */
public class RecurrentDonorsJob implements Queueable {

    public void execute(QueueableContext context) {
        Logger.init(context.getJobId());
        Logger.log('Starting to look for lost recurrent donors');
        reportAndUnmarkLostRecurrentDonors();
        Logger.log('Looking for lost recurrent donors finished');
        Logger.closeAndStore();
    }
    
    /**
     * Checks if all recurrent donors sent a recurring donations in a last month and marks those who did not
     */
    public static void reportAndUnmarkLostRecurrentDonors() {
        Date monthAgo = Date.today().addMonths(-1);
        List<Contact> recurrentDonors = [SELECT Id, Pravidelny_darce__c, Email, (SELECT Id, Datum__c, Pravidelny_dar__c FROM Dary__r WHERE Datum__c >= :monthAgo) FROM Contact WHERE Pravidelny_darce__c = true WITH SECURITY_ENFORCED];

        List<Contact> lostDonors = new List<Contact>();

        for (Contact donor: recurrentDonors) {
            Boolean paidInLastMonth = false;
            for (Dar__c dar: donor.Dary__r) {
                if (dar.Pravidelny_dar__c) {
                    paidInLastMonth = true;
                    break;
                }
            }

            System.debug(donor.Email + ' ' + paidInLastMonth);

            if (!paidInLastMonth) {
                donor.Pravidelny_darce__c = false;
                donor.Ztraceny_pravidelny_darce__c = true;
                Logger.log(LoggingLevel.WARN, 'Recurrent donor ' + donor.Email + ' did not sent a recurrent donation last month');
                lostDonors.add(donor);
            }
        }

        update lostDonors;
    }

}
