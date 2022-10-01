/**
 * Created by booka on 01.10.2022.
 */

@IsTest
private class DealTriggerHandler_Test {

    static final String RECORD_TYPE_DEAL_SALE = Schema.SObjectType.Deal__c.getRecordTypeInfosByName().get('Sale').getRecordTypeId();
    static final String RECORD_TYPE_DEAL_LEASE = Schema.SObjectType.Deal__c.getRecordTypeInfosByName().get('Lease').getRecordTypeId();
    static final String RECORD_TYPE_CONTACT_PROPERTY_OWNER = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Property Owner').getRecordTypeId();
    static final String OPEN = 'Open';

    @testSetup
    static void setup() {

        List<Contact> contactsToInsert = new List<Contact>{
                new Contact (LastName = 'A',
                        RecordTypeId = RECORD_TYPE_CONTACT_PROPERTY_OWNER,
                        Phone = '+375336337572'),
                new Contact (LastName = 'B',
                        RecordTypeId = RECORD_TYPE_CONTACT_PROPERTY_OWNER,
                        Phone = '++375295800053')
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

    static testMethod void triggerDealsTest() {
        Deal__c deal = [SELECT Id, Status__c FROM Deal__c WHERE Status__c = 'Open' LIMIT 1];
        deal.Status__c = 'Closed Won';
        update deal;
    }
}