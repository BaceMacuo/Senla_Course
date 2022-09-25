/**
 * Created by booka on 25.09.2022.
 */

public with sharing class LogManager {

    public class LogWrapper {
        public String message {get; set;}
        public String type {get; set;}
    }

    public static List<Log__c> createLogs(LogWrapper wrapper, Integer count, Boolean inserting) {
        List <Log__c> createLogsList = new List<Log__c>();

        for (Integer i=0;i<count;i++){
            Log__c log = new Log__c();
            log.Type__c = wrapper.type;
            log.Message__c = wrapper.message;
            createLogsList.add(log);
        }

        if(inserting) insert createLogsList;
        return createLogsList;
    }

    public static List<Log__c> getLogsByIds(List<Id> ids) {
        List<Log__c> logsList = [SELECT Name, Type__c, Message__c FROM Log__c WHERE Id IN :ids];
        return logsList;
    }

    public static List<Log__c> updateLogs(List<Id> ids, LogWrapper wrapper, Boolean updating) {
        List<Log__c> logsList = [SELECT Name, Type__c, Message__c FROM Log__c WHERE Id IN :ids];
        List<Log__c> updatedLogsList = new List<Log__c>();

        for (Log__c log : logsList) {
            log.Type__c = wrapper.type;
            log.Message__c = wrapper.message;
            updatedLogsList.add(log);
        }

        if(updating) update updatedLogsList;
        return updatedLogsList;
    }

    public static void deleteLogs(List<Id> ids) {
        delete [SELECT Id FROM Log__c WHERE Id IN :ids];
    }
}