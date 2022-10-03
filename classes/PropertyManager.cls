/**
 * Created by booka on 25.09.2022.
 */

public with sharing class PropertyManager {

    public class PropertyWrapper {
        public Id owner {get; set;}
        public String address {get; set;}
        public Decimal rent {get; set;}
        public Decimal selling {get; set;}
    }

    public static List<Property__c> createProperties(PropertyWrapper wrapper, Integer count, Boolean inserting) {
        List <Property__c> createPropertiesList = new List<Property__c>();

        for (Integer i=0;i<count;i++){
            Property__c property = new Property__c();
            property.Address__c = wrapper.address;
            property.Selling_Price__c = wrapper.selling;
            property.Rent_price__c = wrapper.rent;
            property.Owner__c = wrapper.owner;
            createPropertiesList.add(property);
        }

        if(inserting) insert createPropertiesList;
        return createPropertiesList;
    }

    public static List<Property__c> getPropertiesByIds(List<Id> ids) {
        List<Property__c> propertiesList = [SELECT Name, Address__c, Owner__c, Selling_Price__c, Rent_price__c FROM Property__c WHERE Id IN :ids];
        return propertiesList;
    }

    public static List<Property__c> updateProperties(List<Id> ids, PropertyWrapper wrapper, Boolean updating) {
        List<Property__c> propertiesList = [SELECT Name, Address__c, Owner__c, Selling_Price__c, Rent_price__c FROM Property__c WHERE Id IN :ids];
        List<Property__c> updatedPropertiesList = new List<Property__c>();

        for (Property__c property : propertiesList) {
            property.Address__c = wrapper.address;
            property.Selling_Price__c = wrapper.selling;
            property.Rent_price__c = wrapper.rent;
            property.Owner__c = wrapper.owner;
            updatedPropertiesList.add(property);
        }

        if(updating) update updatedPropertiesList;
        return updatedPropertiesList;
    }

    public static void deleteProperties(List<Id> ids) {
        delete [SELECT Id FROM Property__c WHERE Id IN :ids];
    }
}