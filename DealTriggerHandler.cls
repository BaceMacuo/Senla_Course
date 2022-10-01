/**
 * Created by booka on 01.10.2022.
 */

public with sharing class DealTriggerHandler {

    static final String RECORD_TYPE_DEAL_SALE = Schema.SObjectType.Deal__c.getRecordTypeInfosByName().get('Sale').getRecordTypeId();
    static final String CLOSED_WON = 'Closed Won';

    public void afterUpdateMain(List<Deal__c> dealsNew){
        afterUpdate(dealsNew);
    }

    public void afterUpdate(List<Deal__c> dealsNew){

        List<Id> propertiesIds = new List<Id>();
        List<Deal__c> dealsClosedWon = new List<Deal__c>();

        for(Deal__c d : dealsNew){
            if(d.Status__c == CLOSED_WON && d.RecordTypeId == RECORD_TYPE_DEAL_SALE) {
                propertiesIds.add(d.Property__c);
                dealsClosedWon.add(d);
            }
        }

        List<Deal__c> updateDeals = [SELECT Id, Status__c, RecordTypeId
                                    FROM Deal__c
                                    WHERE Property__c IN : propertiesIds
                                    AND RecordTypeId =: RECORD_TYPE_DEAL_SALE
                                    AND (NOT Status__c LIKE : 'Closed')
                                    AND (NOT Id IN : dealsClosedWon)];

        for(Deal__c deal: updateDeals){
            deal.Status__c = 'Closed Lost';
        }
        update updateDeals;
    }

}