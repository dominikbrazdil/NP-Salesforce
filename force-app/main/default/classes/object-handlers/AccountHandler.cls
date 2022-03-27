public without sharing class AccountHandler {
    
    private String name;
    private String description;

    public Account build() {
        return new Account(
        	Name = this.name,
            Description = this.description
        );
    }

    public AccountHandler setName(String name) {
        if (!String.isEmpty(name)) {
            this.name = name.left(30);
        }
        return this;
    }

    public AccountHandler setDescription(String description) {
        this.description = description;
        return this;
    }
}