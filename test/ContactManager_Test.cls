/**
 * Created by booka on 01.10.2022.
 */

@IsTest
private class ContactManager_Test {

    static final String RECORD_TYPE_CONTACT_PROPERTY_OWNER = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Property Owner').getRecordTypeId();
    static final String RECORD_TYPE_CONTACT_BROKER = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Broker').getRecordTypeId();
    static final Integer COUNTER = 2;

    @TestSetup
    static void setup() {
        List<Contact> contactsToInsert = new List<Contact>{
                new Contact (LastName = 'A',
                        RecordTypeId = RECORD_TYPE_CONTACT_BROKER,
                        Phone = '+375336337572',
                        HomePhone = '652243',
                        Email = 'a@gmail.com'),
                new Contact (LastName = 'B',
                        RecordTypeId = RECORD_TYPE_CONTACT_PROPERTY_OWNER,
                        Phone = '++375295800053',
                        HomePhone = '660043',
                        Email = 'b@gmail.com'),
                new Contact (LastName = 'C',
                        RecordTypeId = RECORD_TYPE_CONTACT_PROPERTY_OWNER,
                        Phone = '+3752948530047',
                        HomePhone = '785894',
                        Email = 'c@gmail.com')
        };
        insert contactsToInsert;
    }

    @IsTest
    static void testGetContactsByIds()
    {
        List<Contact> contacts = [SELECT Name, RecordTypeId, Phone, HomePhone, Email FROM Contact];
        List<Id> idsContact = new List<Id>(new Map<Id, Contact>([SELECT Id FROM Contact]).keySet());

        List<Contact> contactsFromConManager = ContactManager.getContactsByIds(idsContact);

        system.assertEquals(contacts,contactsFromConManager);
    }

    @IsTest
    static void testDeleteContacts()
    {
        List<Id> idsContact = new List<Id>(new Map<Id, Contact>([SELECT Id FROM Contact]).keySet());

        ContactManager.deleteContacts(idsContact);
        List<Id> idsContactAfterDelete = new List<Id>(new Map<Id, Contact>([SELECT Id FROM Contact]).keySet());

        System.assertEquals(0, idsContactAfterDelete.size());
    }

    @IsTest
    static void testCreateContacts(){
        ContactManager.ContactWrapper wrapper = new ContactManager.ContactWrapper();
        wrapper.firstName = 'Test Contact';
        wrapper.lastName = 'Created';
        wrapper.recordTypeId = RECORD_TYPE_CONTACT_PROPERTY_OWNER;
        wrapper.phone = '+375292827262';
        wrapper.homePhone = '661231';
        wrapper.email = 'test_contact@created.prop';

        List<Contact> contactsFalseInsert = ContactManager.createContacts(wrapper, COUNTER, false);
        List<Contact> contactsNull = [SELECT Id FROM Contact WHERE LastName = 'Created'];
        System.assertEquals(2, contactsFalseInsert.size());
        System.assertEquals(0, contactsNull.size());

        List<Contact> contactsTrueInsert = ContactManager.createContacts(wrapper, COUNTER, true);
        List<Contact> contactsWithInsert = [SELECT Id FROM Contact WHERE LastName = 'Created'];
        System.assertEquals(2, contactsTrueInsert.size());
        System.assertEquals(2, contactsWithInsert.size());

    }

    @IsTest
    static void testUpdateContacts(){

        List<Id> idsContacts = new List<Id>(new Map<Id, Contact>([SELECT Id FROM Contact]).keySet());

        ContactManager.ContactWrapper wrapper = new ContactManager.ContactWrapper();
        wrapper.firstName = 'Test Contact';
        wrapper.lastName = 'Created';
        wrapper.recordTypeId = RECORD_TYPE_CONTACT_PROPERTY_OWNER;
        wrapper.phone = '+375292827262';
        wrapper.homePhone = '661231';
        wrapper.email = 'test_contact@created.prop';

        List<Contact> contactsFalseUpdate = ContactManager.updateContacts(idsContacts, wrapper, false);
        List<Contact> contactsNull = [SELECT Id FROM Contact WHERE LastName = 'Created'];
        System.assertEquals(3, contactsFalseUpdate.size());
        System.assertEquals(0, contactsNull.size());

        List<Contact> contactsTrueUpdate = ContactManager.updateContacts(idsContacts, wrapper, true);
        List<Contact> contactsWithUpdate = [SELECT Id FROM Contact WHERE LastName = 'Created'];
        System.assertEquals(3, contactsTrueUpdate.size());
        System.assertEquals(3, contactsWithUpdate.size());
    }
}