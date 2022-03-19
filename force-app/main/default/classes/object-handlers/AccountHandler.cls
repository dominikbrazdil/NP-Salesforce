public without sharing class AccountHandler {
    public static Account build(DarujmeTransaction tr) {
        return new Account(
        	Name = tr.pledge.donor.getAccountName().left(30),
            Description = 'Created from Darujme.cz import'
        );
    }
}