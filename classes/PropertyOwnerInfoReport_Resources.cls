/**
 * Created by booka on 01.11.2022.
 */

global with sharing class PropertyOwnerInfoReport_Resources {
    private final Contact con;

    public PropertyOwnerInfoReport_Resources(ApexPages.StandardController stdController) {
        this.con = (Contact)stdController.getRecord();
    }

    public DealWrapper getIndustrial(){
        List<Deal__c> deals = [SELECT Id, Status__c, Transaction_amount_sale__c, Transaction_amount_after_broker_sale__c
                                FROM Deal__c
                                WHERE Seller__c =: con.Id
                                AND Property__r.RecordType.Name = 'Industrial'];

        DealWrapper wrappers = new DealWrapper(deals);
        return wrappers;
    }

    public DealWrapper getOffice(){
        List<Deal__c> deals = [SELECT Id, Status__c, Transaction_amount_sale__c, Transaction_amount_after_broker_sale__c
                                FROM Deal__c
                                WHERE Seller__c =: con.Id
                                AND Property__r.RecordType.Name = 'Office'];

        DealWrapper wrappers = new DealWrapper(deals);
        return wrappers;

    }

    public DealWrapper getSpace(){
        List<Deal__c> deals = [SELECT Id, Status__c, Transaction_amount_sale__c, Transaction_amount_after_broker_sale__c
                                FROM Deal__c
                                WHERE Seller__c =: con.Id
                                AND Property__r.RecordType.Name = 'Space'];

        DealWrapper wrappers = new DealWrapper(deals);
        return wrappers;

    }

    public class DealWrapper {
        public Integer countDeals {get;set;}
        public Decimal sumFromType {get;set;}
        public Decimal sumAfterPercent {get;set;}

        public DealWrapper(List<Deal__c> deals) {
            this.countDeals = 0;
            this.sumFromType = 0;
            this.sumAfterPercent = 0;

            for (Deal__c deal : deals) {
                this.sumFromType += deal.Transaction_amount_sale__c;
                this.sumAfterPercent += deal.Transaction_amount_after_broker_sale__c;
                if (deal.Status__c == 'Closed Won') {
                    this.countDeals += 1;
                }
            }
        }
    }
//    Industrial
//    Office
//    Space
}