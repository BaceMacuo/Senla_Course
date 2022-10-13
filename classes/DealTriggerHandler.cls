/**
 * Created by booka on 01.10.2022.
 */

public with sharing class DealTriggerHandler extends TriggerHandler{

    static final String RECORD_TYPE_DEAL_SALE = Schema.SObjectType.Deal__c.getRecordTypeInfosByName().get('Sale').getRecordTypeId();
    static final String CLOSED_WON = 'Closed Won';

    public override void afterUpdate() {

        List<Id> propertyIds = new List<Id>();

        for (Id dealId : Trigger.newMap.keySet()) {
            Deal__c newDeal = ((Deal__c) Trigger.newMap.get(dealId));

            if (newDeal.RecordTypeId == RECORD_TYPE_DEAL_SALE || newDeal.Status__c != CLOSED_WON) continue;
            if (newDeal.Status__c != Trigger.oldMap.get(dealId).get(Deal__c.Status__c)) propertyIds.add(newDeal.Property__c);
        }

        if (!propertyIds.isEmpty()) {
            List<Deal__c> getNotClosedSaleDealsByProperties = [
                SELECT Id
                FROM Deal__c
                WHERE Property__c IN :propertyIds
                AND Status__c NOT IN ('Closed Won', 'Closed', 'Closed Lost')
                AND RecordTypeId = :RECORD_TYPE_DEAL_SALE
                ];

            for (Deal__c dl : getNotClosedSaleDealsByProperties) {
                dl.Status__c = 'Closed Lost';
            }

            TriggerHandler.bypass('DealTriggerHandler');
            Database.SaveResult[] results = Database.update(getNotClosedSaleDealsByProperties, false);
            TriggerHandler.clearBypass('DealTriggerHandler');

        }
    }
}