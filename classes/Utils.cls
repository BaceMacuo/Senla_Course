/**
 * Created by booka on 10.10.2022.
 */

public with sharing class Utils {
    public static String getJSONInfo(Id id) {

        Deal__c deal = DealManager.getDealsById(id, 'id, Seller__c, Buyer__c, Rental_start__c, End_of_lease__c');
        Id pId = DealManager.getDealsById(id, 'Property__c').Property__c;
        Property__c propertyInDeal = PropertyManager.getPropertiesById(id, 'Address__c, City__c, Country__c, Latitude__c, Longitude__c');

        Contact buyer = ContactManager.getContactsById(deal.Buyer__c, 'id, FirstName, LastName, Email');
        Contact seller = ContactManager.getContactsById(deal.Seller__c, 'id, FirstName, LastName, Email');

        Datetime dt = Datetime.now();
        Date sd = deal.Rental_start__c;
        Date ed = deal.End_of_lease__c;

        Client client = new Client (buyer.Id, buyer.FirstName, buyer.LastName, buyer.Email);
        Client owner = new Client (seller.Id, seller.FirstName, seller.LastName, seller.Email);
        LocationWrapper locationWrapper = new LocationWrapper(propertyInDeal.Country__c, propertyInDeal.City__c,
                propertyInDeal.Address__c, propertyInDeal.Latitude__c, propertyInDeal.Longitude__c);
        Property property = new Property(pId, owner, locationWrapper);

        Info info = new Info(dt, sd, ed, client, property);

        return JSON.serialize(info);
    }
}