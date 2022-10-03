/**
 * Created by booka on 02.10.2022.
 */

@IsTest
private class PropertyManager_Test {

    static final String RECORD_TYPE_CONTACT_PROPERTY_OWNER = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Property Owner').getRecordTypeId();
    static final Integer COUNTER = 2;

    @testSetup
    static void setup() {

        List<Contact> contactsToInsert = new List<Contact>{
                new Contact (LastName = 'A',
                        RecordTypeId = RECORD_TYPE_CONTACT_PROPERTY_OWNER,
                        Phone = '+375336337572'),
                new Contact (LastName = 'B',
                        RecordTypeId = RECORD_TYPE_CONTACT_PROPERTY_OWNER,
                        Phone = '++375295800053'),
                new Contact (LastName = 'test',
                        RecordTypeId = RECORD_TYPE_CONTACT_PROPERTY_OWNER,
                        Phone = '+375331111111')
        };
        insert contactsToInsert;
        Property__c property = new Property__c(
                Address__c = 'Limoja',
                Selling_Price__c = 12000,
                Rent_price__c = 120,
                Owner__c = contactsToInsert[0].Id
        );
        insert property;
        Property__c property1 = new Property__c(
                Address__c = 'Push',
                Selling_Price__c = 13000,
                Rent_price__c = 130,
                Owner__c = contactsToInsert[1].Id
        );
        insert property1;
        Property__c property2 = new Property__c(
                Address__c = 'Dub',
                Selling_Price__c = 14000,
                Rent_price__c = 140,
                Owner__c = contactsToInsert[2].Id
        );
        insert property2;
    }

    @IsTest
    static void testGetPropertiesByIds(){

        List<Property__c> properties = [SELECT Name, Address__c, Owner__c, Selling_Price__c, Rent_price__c  FROM Property__c];
        List<Id> idsProperties = new List<Id>(new Map<Id, Property__c>([SELECT Id FROM Property__c]).keySet());

        List<Property__c> propertiesFromDealManager = PropertyManager.getPropertiesByIds(idsProperties);

        system.assertEquals(properties,propertiesFromDealManager);
    }

    @IsTest
    static void testDeleteProperties(){

        List<Id> idsProperties = new List<Id>(new Map<Id, Property__c>([SELECT Id FROM Property__c]).keySet());
        PropertyManager.deleteProperties(idsProperties);

        List<Id> idsPropertiesAfterDelete = new List<Id>(new Map<Id, Property__c>([SELECT Id FROM Property__c]).keySet());

        system.assertEquals(0,idsPropertiesAfterDelete.size());
    }

    @IsTest
    static void testCreateProperties(){
        Contact owner = [SELECT Id FROM Contact WHERE LastName = 'test'];

        PropertyManager.PropertyWrapper wrapper = new PropertyManager.PropertyWrapper();
        wrapper.owner = owner.Id;
        wrapper.address = 'Dovatoro';
        wrapper.rent = 150;
        wrapper.selling = 15000;

        List<Property__c> propertiesFalseInsert = PropertyManager.createProperties(wrapper, COUNTER, false);
        List<Property__c> propertiesNull = [SELECT Id FROM Property__c WHERE Address__c = 'Dovatoro'];
        System.assertEquals(2, propertiesFalseInsert.size());
        System.assertEquals(0, propertiesNull.size());

        List<Property__c> propertiesTrueInsert = PropertyManager.createProperties(wrapper, COUNTER, true);
        List<Property__c> propertiesWithInsert = [SELECT Id FROM Property__c WHERE Address__c = 'Dovatoro'];
        System.assertEquals(2, propertiesTrueInsert.size());
        System.assertEquals(2, propertiesWithInsert.size());
    }

    @IsTest
    static void testUpdateProperties(){
        List<Id> idsProperties = new List<Id>(new Map<Id, Property__c>([SELECT Id FROM Property__c]).keySet());

        PropertyManager.PropertyWrapper wrapper = new PropertyManager.PropertyWrapper();
        wrapper.address = 'Dovatoro';
        wrapper.rent = 150;
        wrapper.selling = 15000;

        List<Property__c> propertiesFalseUpdate = PropertyManager.updateProperties(idsProperties, wrapper, false);
        List<Property__c> propertiesNull = [SELECT Id FROM Property__c WHERE Address__c = 'Dovatoro'];
        System.assertEquals(3, propertiesFalseUpdate.size());
        System.assertEquals(0, propertiesNull.size());

        List<Property__c> propertiesTrueUpdate = PropertyManager.updateProperties(idsProperties, wrapper, true);
        List<Property__c> propertiesWithUpdate = [SELECT Id FROM Property__c WHERE Address__c = 'Dovatoro'];
        System.assertEquals(3, propertiesTrueUpdate.size());
        System.assertEquals(3, propertiesWithUpdate.size());

    }
}