/**
 * Created by booka on 01.10.2022.
 */

trigger DealTrigger on Deal__c (after update) {

    DealTriggerHandler triggerHandler = new DealTriggerHandler();

    if(Trigger.isUpdate && Trigger.isAfter){
        triggerHandler.afterUpdateMain(Trigger.new);
    }

}