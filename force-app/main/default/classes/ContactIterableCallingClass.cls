public with sharing class ContactIterableCallingClass implements Iterable<Contact> {
    public Iterator<Contact> Iterator() {
        return new ContactIterable();
    }
}