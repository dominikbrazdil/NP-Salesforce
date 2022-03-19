trigger AddDonorsToCampaigns on Dar__c (after insert) {
    Set<CampaignMember> membersToAdd = new Set<CampaignMember>();

    List<Dar__c> insertedDary = new List<Dar__c>(
        [SELECT Id, darce__c, Kampan__c FROM Dar__c WHERE Id IN :Trigger.New]);

    List<CampaignMember> existingMembers = [SELECT ContactId, CampaignId FROM CampaignMember WHERE ContactId IN :Utils.mapToId(insertedDary, Dar__c.Darce__c)];

    for (Dar__c dar: insertedDary) {
        Boolean alreadyMember = false;
        for (CampaignMember m: existingMembers) {
            if (m.ContactId == dar.darce__c && m.CampaignId == dar.Kampan__c) {
                alreadyMember = true;
                break;
            }
        }

        if (!alreadyMember) {
            membersToAdd.add(new CampaignMember(
                ContactId = dar.darce__c,
                CampaignId = dar.Kampan__c
            ));
        }
    }

    insert new List<CampaignMember>(membersToAdd);
}