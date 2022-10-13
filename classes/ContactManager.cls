/**
 * Created by booka on 25.09.2022.
 */

public with sharing class ContactManager {

    public class ContactWrapper {
        public String firstName {get; set;}
        public String lastName {get; set;}
        public Id recordTypeId {get; set;}
        public String phone {get; set;}
        public String homePhone {get; set;}
        public String email {get; set;}
    }

    public static List<Contact> createContacts(ContactWrapper wrapper, Integer count, Boolean inserting) {
        List <Contact> createContactsList = new List<Contact>();

        for (Integer i=0;i<count;i++){
            Contact contact = new Contact();
            contact.FirstName = wrapper.firstName;
            contact.LastName = wrapper.LastName;
            contact.RecordTypeId = wrapper.recordTypeId;
            contact.Phone = wrapper.phone;
            contact.HomePhone = wrapper.homePhone;
            contact.Email = wrapper.email;
            createContactsList.add(contact);
        }

        if(inserting) insert createContactsList;
        return createContactsList;
    }

    public static List<Contact> getContactsByIds(List<Id> ids) {
        List<Contact> contactsList = [SELECT Name, RecordTypeId, Phone, HomePhone, Email FROM Contact WHERE Id IN :ids];
        return contactsList;
    }

    public static Contact getContactsById(Id id, String fields) {
        return Database.query('SELECT ' + fields + ' FROM Contact WHERE Id =:id');
    }

    public static List<Contact> updateContacts(List<Id> ids, ContactWrapper wrapper, Boolean updating) {
        List<Contact> contactsList = [SELECT Name, RecordTypeId, Phone, HomePhone, Email FROM Contact WHERE Id IN :ids];
        List<Contact> updatedContactsList = new List<Contact>();

        for (Contact contact : contactsList) {
            contact.FirstName = wrapper.firstName;
            contact.LastName = wrapper.lastName;
            contact.RecordTypeId = wrapper.recordTypeId;
            contact.Phone = wrapper.phone;
            contact.HomePhone = wrapper.homePhone;
            contact.Email = wrapper.email;
            updatedContactsList.add(contact);
        }

        if(updating) update updatedContactsList;
        return updatedContactsList;
    }

    public static void deleteContacts(List<Id> ids) {
        delete [SELECT Id FROM Contact WHERE Id IN :ids];
    }

}