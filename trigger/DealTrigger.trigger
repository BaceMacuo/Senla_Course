/**
 * Created by booka on 01.10.2022.
 */

trigger DealTrigger on Deal__c (after update) {

    new DealTriggerHandler().run();

}
