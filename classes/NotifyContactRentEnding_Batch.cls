/**
 * Created by booka on 10.10.2022.
 */

public class NotifyContactRentEnding_Batch implements Database.Batchable<sObject> {

    public static final Date TOMORROW=Date.today().addDays(1);
    public static final Id DEAL_TYPE_LEASE = [SELECT Id FROM RecordType WHERE Name = 'Lease' LIMIT 1].Id;

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
                'SELECT ID ' +
                        'FROM Deal__c ' +
                        'Where RecordTypeId = ' + DEAL_TYPE_LEASE +
                        'AND End_of_lease__c =' + TOMORROW
        );
    }

    public void execute(Database.BatchableContext bc, List<Deal__c> deals){
        List <NotifyClientRentEnding__e> eventList = new  List <NotifyClientRentEnding__e>();
        String[] emailFromBuyer;
        for (Deal__c deal : deals) {
            NotifyClientRentEnding__e event = new NotifyClientRentEnding__e(DealId__c = deal.Id, Info__c = Utils.getJSONInfo(deal.Id));
            eventList.add(event);
            emailFromBuyer.add(deal.Buyer__r.Email);
        }
        sendEmail(emailFromBuyer);

        List<Database.SaveResult> results = EventBus.publish(eventList);
        for (Database.SaveResult sr : results) {
            if (!sr.isSuccess()){
                System.debug('Problem. Result dont save.');
                break;
            }
        }
    }

    public void finish(Database.BatchableContext bc){}

    public Static void sendEmail(String[] emailFromBuyer){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] addresses = emailFromBuyer;
        mail.setToAddresses(addresses);
        mail.setReplyTo('support@acme.com');
        mail.setSenderDisplayName('BASE');
        mail.setBccSender(false);
        mail.setPlainTextBody('go out, tomorrow!');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }

}