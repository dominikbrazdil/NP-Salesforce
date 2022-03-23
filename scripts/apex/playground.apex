

Map<Integer, List<Integer>> contactToCampaigns = new Map<Integer, List<Integer>>{1=>new List<Integer>{1}};
contactToCampaigns.get(1).add(2);
System.debug(contactToCampaigns);