public with sharing class ContactIterable implements Iterator<Contact> {
    List<Contact> contactList{get; set;}
    Integer i{get; set;}
    public ContactIterable() {
        contactList = [SELECT Id, Description from Contact];
        i = 0;
    }

    public Boolean hasNext(){
        if(i >= contactList.size()){
            System.debug('hasNext false block called -> ' + i);
            return false;
        } else {
            System.debug('hasNext true block called -> ' + i);
            return true;
        }
    }

    public Contact next(){
        i++;
        System.debug('Next called -> ' + i);
        return contactList[i-1];
    }
}