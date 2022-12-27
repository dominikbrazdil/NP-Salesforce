public without sharing class Utils {
    
    /**
     * Maps the list of SObjects to specific object's String fields list
     */
    public static List<String> mapToString(List<SObject> objects, SObjectField field) {
        List<String> mappedValues = new List<String>();
        for (SObject o: objects){
            mappedValues.add((String)o.get(field));
        }
        return mappedValues;
    }

    /**
     * Maps the list of SObjects to list of SObjects mapped to them
     */
    public static List<SObject> mapToSObject(List<SObject> objects, SObjectField field) {
        List<SObject> mappedValues = new List<SObject>();
        for (SObject o: objects){
            if (o.getSObject(field) != null) {
                mappedValues.add(o.getSObject(field));
            }
        }
        return mappedValues;
    }

    /**
     * Maps the list of SObjects to specific object's ID fields list
     */
    public static List<Id> mapToId(List<SObject> objects, SObjectField field) {
        List<Id> mappedValues = new List<Id>();
        for (SObject o: objects){
            mappedValues.add((Id)o.get(field));
        }
        return mappedValues;
    }

    /**
     * Maps the list of SObjects to specific object's Decimal fields list
     */
    public static List<Decimal> mapToDecimal(List<SObject> objects, SObjectField field) {
        List<Decimal> mappedValues = new List<Decimal>();
        for (SObject o: objects){
            mappedValues.add((Decimal)o.get(field));
        }
        return mappedValues;
    }

    /**
     * Finds one object in the list of SObjects with specific filed containing given value
     */
    public static SObject find(List<SObject> objects, SObjectField fieldToFilterBy, Object filterValue) {
        for (SObject o: objects) {
            if (o.get(fieldToFilterBy) == filterValue) {
                return o;
            }
        }
        return null;
    }

    /**
     * Parses date from string format to DateTime object
     * Assumes 4-digit year, 2-digit months, days, hours, minutes and seconds
     * format - y, M, d, h, m, s values separated by some separator, e.g. 'y.M.d h:m:s' or 'd-Y-M'
     */
    public static DateTime parseDate(String dateString, String format) {

        Integer years, months, days, hours, minutes, seconds;

        for(Integer i = 0; i < format.length(); i++) {
            String character = format.substring(i, i+1);
            switch on character {
                when 'y' {
                    years = Integer.valueOf(dateString.left(4));
                    dateString = dateString.substring(4);
                }
                when 'M' {
                    months = Integer.valueOf(dateString.left(2));
                    dateString = dateString.substring(2);
                }
                when 'd' {
                    days = Integer.valueOf(dateString.left(2));
                    dateString = dateString.substring(2);
                }
                when 'h' {
                    Integer hoursLength = dateString.left(2).isNumeric() ? 2 : 1; 
                    hours = Integer.valueOf(dateString.left(hoursLength));
                    dateString = dateString.substring(hoursLength);
                }
                when 'm' {
                    minutes = Integer.valueOf(dateString.left(2));
                    dateString = dateString.substring(2);
                }
                when 's' {
                    seconds = Integer.valueOf(dateString.left(2));
                    dateString = dateString.substring(2);
                }
                when else {
                    dateString = dateString.substring(1);
                }
            }
        }

        return DateTime.newInstance(years, months, days, hours, minutes, seconds);
    }

}
