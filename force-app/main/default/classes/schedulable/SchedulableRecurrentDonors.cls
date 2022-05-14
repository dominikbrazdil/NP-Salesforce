/**
 * Schedulable job for recurrent donors check
 */
global class SchedulableRecurrentDonors implements Schedulable {
    
    global void execute(SchedulableContext sc) {
        System.enqueueJob(new RecurrentDonorsJob());
    }
}
