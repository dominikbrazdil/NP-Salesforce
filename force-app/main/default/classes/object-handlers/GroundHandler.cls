public class GroundHandler {
    
    private String name;
    private Integer contractID;
    private String measures;
    private String type;
    private String parcelID;
    private Decimal area;

    public static Map<Decimal, List<Ground__c>> getGroundsForContractIds(List<Decimal> contractIds) {
        Map<Decimal, List<Ground__c>> contractToGroundsMap = new Map<Decimal, List<Ground__c>>();

        for (Ground__c ground: [SELECT Id, ID_Parcely__c, Pachtovni_smlouva__r.Ziva_Puda_ID__c FROM Ground__c WHERE Pachtovni_smlouva__r.Ziva_Puda_ID__c IN :contractIds]) {
            Decimal contractId = ground.Pachtovni_smlouva__r.Ziva_Puda_ID__c;

            if (contractToGroundsMap.containsKey(contractId)) {
                contractToGroundsMap.get(contractId).add(ground);
            } else {
                contractToGroundsMap.put(contractId, new List<Ground__c>{ground});
            }
        }

        return contractToGroundsMap;
    }

    public Ground__c build() {
        Contract__c contract = new Contract__c(Ziva_Puda_ID__c = this.contractID);

        return new Ground__c(
            name = name,
            Pachtovni_smlouva__r = contract,
            Opatreni__c = this.measures,
            Typ__c = this.type,
            ID_parcely__c = this.parcelID,
            Plocha__c = this.area
        );
    }

    public GroundHandler setName(String name) {
        this.name = name;
        return this;
    }

    public GroundHandler setContractId(Integer id) {
        this.contractID = id;
        return this;
    }

    public GroundHandler setMeasures(List<String> measures) {
        this.measures = String.join(measures, ';');
        return this;
    }

    public GroundHandler setType(String type) {
        this.type = type;
        return this;
    }

    public GroundHandler setParcelID(String ID) {
        this.parcelID = ID;
        return this;
    }

    public GroundHandler setArea(Decimal area) {
        this.area = area;
        return this;
    }
}
