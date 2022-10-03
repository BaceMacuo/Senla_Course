/**
 * Created by booka on 25.09.2022.
 */

@IsTest
private class TestData {

    public static final Id STANDARD_PLATFORM_USER_PROFILE_ID =
            [SELECT Id FROM Profile WHERE Name = 'Standard Platform User' LIMIT 1].Id;

    public static final Id DEFAULT_DEAL_TYPE = Schema.SObjectType.Deal__c.getRecordTypeInfosByName()
            .get('Sale').getRecordTypeId();

    public static Log__c createLog() {
        Log__c log= new Log__c(Type__c = 'DEBUG', Message__c = 'Message');
        insert log;
        return log;
    }

    public static Contact createContact() {
        Contact contact = new Contact(FirstName = 'firstName', LastName = 'lastName');
        insert contact;
        return contact;
    }

    public static List<Property__c> createProperties(Integer counter) {
        List<Property__c> properties = new List<Property__c>(counter);
        for (Integer i = 0; i < counter; i++) {
            properties[i] = new Property__c(Address__c = 'Limoja ' + i,
                    Rent_Price__c = 10 / i,
                    Selling_Price__c = 999 - i,
                    Owner__c = '123456789');
        }
        insert properties;
        return properties;
    }

    public static Deal__c createDeal() {
        Deal__c deal = new Deal__c(Status__c = 'Closed', RecordTypeId = DEFAULT_DEAL_TYPE);
        insert deal;
        return deal;
    }

    public static List<Contact> createContact(Integer counter) {
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i < counter; i++) {
            contacts[i] = new Contact(FirstName = 'firstName' + i,
                    LastName = 'lastName' + i);
        }
        insert contacts;
        return contacts;
    }

    public static User createClientUser(Contact cont) {
        User user = new User(ProfileId = STANDARD_PLATFORM_USER_PROFILE_ID,
                ContactId = cont.Id, LastName = cont.LastName,
                LanguageLocaleKey = 'en_US', Username = cont.LastName + '@username.com',
                Email = cont.LastName + '@test.com', Alias = 'bbase',
                TimeZoneSidKey = 'Europe/Minsk', LocaleSidKey = 'en_US', EmailEncodingKey = 'UTF-8');
        insert user;
        return user;
    }

}