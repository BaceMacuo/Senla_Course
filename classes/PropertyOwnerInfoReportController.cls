/**
 * Created by booka on 01.11.2022.
 */

global with sharing class PropertyOwnerInfoReportController {
    private final Contact contact;

    public PropertyOwnerInfoReportController(ApexPages.StandardController stdController) {
        this.contact = (Contact)stdController.getRecord();
    }

    public List<DealWrapper> getDataForTable(){
        List<DealWrapper> wrappers = new List<DealWrapper>();
        Boolean findSameType;
        String propertyRecordType;

        String fields = 'Id, Status__c, Transaction_amount_sale__c, Transaction_amount_after_broker_sale__c, Property__r.RecordType.Name';
        List<Deal__c> deals = DealManager.getDealsByOwnerId(contact.Id, fields);

        for (Deal__c deal : deals) {
            findSameType = false;
            propertyRecordType = deal.Property__r.RecordType.Name;

            for (DealWrapper wrapper : wrappers) {
                if (propertyRecordType == wrapper.propertyRecordType) {
                    wrapper.countDeals += 1;
                    wrapper.sumFromType += deal.Transaction_amount_sale__c;
                    wrapper.sumAfterPercent += deal.Transaction_amount_after_broker_sale__c;
                    findSameType = true;
                }
            }
            if (!findSameType) {
                wrappers.add(new DealWrapper(propertyRecordType, 1, deal.Transaction_amount_sale__c, deal.Transaction_amount_after_broker_sale__c));
            }
        }

        return wrappers;
    }

    public class DealWrapper {
        public String propertyRecordType {get; set;}
        public Integer countDeals {get;set;}
        public Decimal sumFromType {get;set;}
        public Decimal sumAfterPercent {get;set;}

        public DealWrapper(String type, Integer countDeals, Decimal sumFromType, Decimal sumAfterPercent) {
            this.propertyRecordType = type;
            this.countDeals = countDeals;
            this.sumFromType = sumFromType;
            this.sumAfterPercent = sumAfterPercent;
        }
    }
}