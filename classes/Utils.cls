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
    public class Response {
        public Date startDate {get; set;}
        public Date endDate {get; set;}
        public String totalRevenue {get; set;}
        public List<DealWrapper> deals {get; set;}

        public Response (Date startDate, Date endDate, List<Deal__c> deals) {
            this.startDate = startDate;
            this.endDate = endDate;
            this.deals = new List<DealWrapper>();
            Decimal revenue = 0;
            for (Deal__c deal : deals) {
                this.deals.add(new DealWrapper(deal));
                revenue += deal.Transaction_amount_rent__c;
            }

            this.totalRevenue = String.valueOf(revenue);
        }
    }
    public class DealWrapper {
        public String sfId {get; set;}
        public String dealType {get; set;}
        public Client realtor {get; set;}
        public Decimal revenue {get; set;}
        public String clientId {get; set;}
        public String propertyId {get; set;}

        public DealWrapper (Deal__c deal) {
            this.sfId = deal.Id;
            this.dealType = deal.RecordType.Name;
            this.realtor = new Client(deal.Seller__r.Id, deal.Seller__r.Email, deal.Seller__r.FirstName, deal.Seller__r.LastName);
            this.revenue = deal.Transaction_amount_rent__c;
            this.clientId = deal.Buyer__r.Id;
            this.propertyId = deal.Property__c;
        }
    }
    public class UpdatePropertyOwner {
        public String propertyId {get; set;}
        public Client owner {get; set;}
    }
}