//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//

public class Nomination {

	public Integer id;
	public String name;
	public Category category;
	public String location;
	public String gps;
	public String description;
	public List<Category> climateRisks;
	public String created;
	public NominationContact contact;
	public Nominating nominating;


	public class Category {
		public String id;
		public String name;
	}

	public class Nominating {
		public String fullName;
		public String firstName;
		public String lastName;
		public String email;
	}

	public class ContactPerson {
		public String fullName;
		public String firstName;
		public String lastName;
		public String email;
		public String phone;
	}

	public class NominationContact {
		public String organization;
		public ContactPerson contaktPerson;
	}

	public Nominace__c createNomination() {
		return new NominationHandler()
		.setId(this.id)
		.setName(this.name)
		.setKategorie(this.category.name)
		.setZamereni(this.getZamereni())
		.setNominatingEmail(this.nominating.email)
		.setNominatedEmail(this.isNominatedValid() ? this.contact.contaktPerson.email : null)
		.build();
	}

	public Account createNominatingAccount() {
		return new AccountHandler()
		.setName(this.nominating.fullName)
		.setDescription('Imported from Kentico')
		.build();
	}

	public Contact createNominatingContact() {
		return new ContactHandler()
		.setEmail(this.nominating.email)
		.setFirstName(getFirstName(this.nominating.fullName))
		.setLastName(getLastName(this.nominating.fullName))
		.setDescription('Imported from Kentico')
		.build();
	}

	public Boolean isNominatedValid() {
		return !String.isEmpty(this.contact.contaktPerson.email)
			&& !String.isEmpty(this.contact.contaktPerson.lastName);
	}

	public Account createNominatedAccount() {
		return new AccountHandler()
		.setName(this.contact.contaktPerson.fullName)
		.setDescription('Imported from Kentico')
		.build();
	}

	public Contact createNominatedContact() {
		return new ContactHandler()
		.setEmail(this.contact.contaktPerson.email)
		.setFirstName(getFirstName(this.contact.contaktPerson.fullName))
		.setLastName(getLastName(this.contact.contaktPerson.fullName))
		.setPhone(this.contact.contaktPerson.phone)
		.setDescription('Imported from Kentico')
		.build();
	}

	private String getZamereni() {
		String zamereni = '';
		for (Category c: this.climateRisks) {
			zamereni += (String.isEmpty(zamereni) ? '' : ', ') + c.name;
		}
		return zamereni;
	}

	private String getFirstName(String fullName) {
		return fullName.contains(' ') ? fullName.split(' ')[0] : null;
	}

	private String getLastName(String fullName) {
		return fullName.contains(' ') ? fullName.split(' ', 2)[1]: fullName;
	}
	
	public static List<Nomination> parse(String json) {
		return (List<Nomination>) System.JSON.deserialize(json, List<Nomination>.class);
	}
}