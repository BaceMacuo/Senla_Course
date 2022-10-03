/**
 * Created by booka on 25.09.2022.
 */

public with sharing class DealManager {

    public class DealWrapper {
        public Id buyer {get; set;}
        public Id seller {get; set;}
        public Id property {get; set;}
        public String status {get; set;}
    }

    public static List<Deal__c> createDeals(DealWrapper wrapper, Integer count, Boolean inserting) {
        List <Deal__c> createDealsList = new List<Deal__c>();

        for (Integer i=0;i<count;i++){
            Deal__c deal = new Deal__c();
            deal.Buyer__c = wrapper.buyer;
            deal.Seller__c = wrapper.seller;
            deal.Property__c = wrapper.property;
            deal.Status__c = wrapper.status;
            createDealsList.add(deal);
        }

        if(inserting) insert createDealsList;
        return createDealsList;
    }

    public static List<Deal__c> getDealsByIds(List<Id> ids) {
        List<Deal__c> dealsList = [SELECT Name, Buyer__c, Seller__c, Property__c, Status__c FROM Deal__c WHERE Id IN :ids];
        return dealsList;
    }

    public static List<Deal__c> updateDeals(List<Id> ids, DealWrapper wrapper, Boolean updating) {
        List<Deal__c> dealsList = [SELECT Name, Buyer__c, Seller__c, Property__c, Status__c FROM Deal__c WHERE Id IN :ids];
        List<Deal__c> updatedDealsList = new List<Deal__c>();

        for (Deal__c deal : dealsList) {
            deal.Buyer__c = wrapper.buyer;
            deal.Seller__c = wrapper.seller;
            deal.Property__c = wrapper.property;
            deal.Status__c = wrapper.status;
            updatedDealsList.add(deal);
        }

        if(updating) update updatedDealsList;
        return updatedDealsList;
    }

    public static void deleteDeals(List<Id> ids) {
        delete [SELECT Id FROM Deal__c WHERE Id IN :ids];
    }
}