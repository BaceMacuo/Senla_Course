/**
 * Created by booka on 01.10.2022.
 */

public with sharing class DealTriggerHandler {

    public void afterUpdateMain(List<Deal__c> dealsNew){
        afterUpdate(dealsNew);
    }

    public void afterUpdate(List<Deal__c> dealsNew){

        List<Property__c> properties = new List<Property__c>();
        List<Deal__c> updateDeals = new List<Deal__c>();

        for(Deal__c d : dealsNew){
            properties.add(d.Property__r);
        }

        for(Property__c property: properties){
            for(Deal__c deal: property.Deals__r){
                if(!deal.Status__c.contains('Closed') && deal.RecordType.Name == 'Sale'){
                    deal.Status__c = 'Closed Lost';
                    updateDeals.add(deal);
                }
            }
        }
        update updateDeals;
    }

}