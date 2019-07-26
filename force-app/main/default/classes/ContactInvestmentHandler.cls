public with sharing class ContactInvestmentHandler {
    public static void checkDupeInvestmentEmail(List<Contact> newContacts) {
        Map<String, Contact> emailToContactMap = new Map<String, Contact>();
        for (Contact con : [SELECT Id, Investment_Email__c, Investment_Status__c from Contact WHERE Investment_Email__c != null AND Investment_Status__c = 'Active']) {
            emailToContactMap.put(con.Investment_Email__c, con);
            System.debug('###: ' + emailToContactMap.keySet());
        }

        for (Contact con : newContacts) {
            if(con.Investment_Email__c != null && con.Investment_Status__c == 'Active') {
                if(!emailToContactMap.containsKey(con.Investment_Email__c)) {
                    emailToContactMap.put(con.Investment_Email__c, con);
                    System.debug('Con: ' + emailToContactMap.get(con.Investment_Email__c));
                } else {
                    System.debug('Error ');
                    con.Investment_Email__c.addError('Duplicate Investment email found');
                }
            }
        }
    }
}