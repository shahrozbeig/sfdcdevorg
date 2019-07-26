global with sharing class ContactDescriptionUpdateBatch implements Database.Batchable<Contact> {
    List<Contact> contactsToUpdate = new List<Contact>();
    global Iterable<Contact> start(Database.BatchableContext batchContext) {
        return new ContactIterableCallingClass();
    }

    global void execute(Database.BatchableContext batchContext, List<Contact> contactList) {
        for (Contact contact : contactList) {
            contact.Description = 'Passed through Batch class';
            contactsToUpdate.add(contact);
        }
        Database.update(contactsToUpdate);
    }

    global void finish(Database.BatchableContext batchContext) {

        System.debug('###: Done');
    }
}