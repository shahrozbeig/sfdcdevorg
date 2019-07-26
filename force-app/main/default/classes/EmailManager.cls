public with sharing class EmailManager {
    public static void sendMail(String[] addresses, String[] subjects, String[] messages) {
        Messaging.SingleEmailMessage[] emails = new Messaging.SingleEmailMessage[]{};
        Integer totalMails = addresses.size();
        for (Integer mailNumber = 0; mailNumber < totalMails; mailNumber++) {
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setSubject(subjects[mailNumber]);
            email.setPlainTextBody(messages[mailNumber]);
            email.setToAddresses(new List<String> {addresses[mailNumber]});
            emails.add(email);
        }
        Messaging.sendEmail(emails);
    }
}