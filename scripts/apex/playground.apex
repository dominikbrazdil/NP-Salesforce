

List<Contact> ns = [SELECT Id, Email, (SELECT Id FROM CampaignMembers), (SELECT Id FROM Vytvorene_nominace__r) FROM Contact];
Integer c = 0;
for(Contact c: ns) {
    if (c.CampaignMembers.size() == 0 && c.Vytvorene_nominace__r.size() ==0 )
    System.debug(c.Email);
}
