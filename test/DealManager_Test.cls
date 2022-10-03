/**
 * Created by booka on 02.10.2022.
 */

@IsTest
private class DealManager_Test {

    static final String RECORD_TYPE_DEAL_SALE = Schema.SObjectType.Deal__c.getRecordTypeInfosByName().get('Sale').getRecordTypeId();
    static final String RECORD_TYPE_DEAL_LEASE = Schema.SObjectType.Deal__c.getRecordTypeInfosByName().get('Lease').getRecordTypeId();
    static final String RECORD_TYPE_CONTACT_PROPERTY_OWNER = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Property Owner').getRecordTypeId();
    static final String OPEN = 'Open';
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
                Owner__c = contactsToInsert[1].Id
        );
        insert property;
        List<Deal__c> dealsToInsert = new List<Deal__c>{
                new Deal__c(
                        Status__c = OPEN,
                        Seller__c = contactsToInsert[1].Id,
                        Property__c = property.Id,
                        Buyer__c = contactsToInsert[0].Id,
                        RecordTypeId = RECORD_TYPE_DEAL_SALE
                ),
                new Deal__c(
                        Status__c = OPEN,
                        Seller__c = contactsToInsert[1].Id,
                        Property__c = property.Id,
                        Buyer__c = contactsToInsert[0].Id,
                        RecordTypeId = RECORD_TYPE_DEAL_LEASE
                ),
                new Deal__c(
                        Status__c = OPEN,
                        Seller__c = contactsToInsert[1].Id,
                        Property__c = property.Id,
                        Buyer__c = contactsToInsert[0].Id,
                        RecordTypeId = RECORD_TYPE_DEAL_SALE
                ),
                new Deal__c(
                        Status__c = 'Closed',
                        Seller__c = contactsToInsert[1].Id,
                        Property__c = property.Id,
                        Buyer__c = contactsToInsert[0].Id,
                        RecordTypeId = RECORD_TYPE_DEAL_LEASE
                )
        };
        insert dealsToInsert;
    }

    @IsTest
    static void testGetDealsByIds(){

        List<Deal__c> deals = [SELECT Name, Buyer__c, Seller__c, Property__c, Status__c FROM Deal__c];
        List<Id> idsDeals = new List<Id>(new Map<Id, Deal__c>([SELECT Id FROM Deal__c]).keySet());

        List<Deal__c> dealsFromDealManager = DealManager.getDealsByIds(idsDeals);

        system.assertEquals(deals,dealsFromDealManager);
    }

    @IsTest
    static void testDeleteDeals(){

        List<Id> idsDeals = new List<Id>(new Map<Id, Deal__c>([SELECT Id FROM Deal__c]).keySet());
        DealManager.deleteDeals(idsDeals);

        List<Id> idsDealsAfterDelete = new List<Id>(new Map<Id, Deal__c>([SELECT Id FROM Deal__c]).keySet());

        system.assertEquals(0,idsDealsAfterDelete.size());
    }

    @IsTest
    static void testCreateDeals(){
        Property__c property = [SELECT Id FROM Property__c WHERE Address__c = 'Limoja'];
        Contact buyer = [SELECT Id FROM Contact WHERE LastName = 'A'];
        Contact seller = [SELECT Id FROM Contact WHERE LastName = 'B'];

        DealManager.DealWrapper wrapper = new DealManager.DealWrapper();
        wrapper.buyer = buyer.Id;
        wrapper.seller = seller.Id;
        wrapper.property = property.Id;
        wrapper.status = 'Awaiting Approval';

        List<Deal__c> dealsFalseInsert = DealManager.createDeals(wrapper, COUNTER, false);
        List<Deal__c> dealsNull = [SELECT Id FROM Deal__c WHERE Status__c = 'Awaiting Approval'];
        System.assertEquals(2, dealsFalseInsert.size());
        System.assertEquals(0, dealsNull.size());

        List<Deal__c> dealsTrueInsert = DealManager.createDeals(wrapper, COUNTER, true);
        List<Deal__c> dealsWithInsert = [SELECT Id FROM Deal__c WHERE Status__c = 'Awaiting Approval'];
        System.assertEquals(2, dealsTrueInsert.size());
        System.assertEquals(2, dealsWithInsert.size());
    }

    @IsTest
    static void testUpdateDeals(){
        List<Id> idsDeals = new List<Id>(new Map<Id, Deal__c>([SELECT Id FROM Deal__c]).keySet());

        Property__c property = [SELECT Id FROM Property__c WHERE Address__c = 'Limoja'];
        Contact buyer = [SELECT Id FROM Contact WHERE LastName = 'test'];

        DealManager.DealWrapper wrapper = new DealManager.DealWrapper();
        wrapper.buyer = buyer.Id;
        wrapper.property = property.Id;
        wrapper.status = 'Awaiting Approval';

        List<Deal__c> dealsFalseInsert = DealManager.updateDeals(idsDeals, wrapper, false);
        List<Deal__c> dealsNull = [SELECT Id FROM Deal__c WHERE Status__c = 'Awaiting Approval'];
        System.assertEquals(4, dealsFalseInsert.size());
        System.assertEquals(0, dealsNull.size());

        List<Deal__c> dealsTrueInsert = DealManager.updateDeals(idsDeals, wrapper, true);
        List<Deal__c> dealsWithInsert = [SELECT Id FROM Deal__c WHERE Status__c = 'Awaiting Approval'];
        System.assertEquals(4, dealsTrueInsert.size());
        System.assertEquals(4, dealsWithInsert.size());

    }
}