/**
 * Created by booka on 02.10.2022.
 */

@IsTest
private class LogManager_Test {
    @TestSetup
    static void setup() {
        List<Log__c> logsToInsert = new List<Log__c>{
                new Log__c (
                        Message__c = 'hi',
                        Type__c = 'DEFAULT'
                ),
                new Log__c (
                        Message__c = 'Priv',
                        Type__c = 'DEFAULT'
                ),
                new Log__c (
                        Message__c = 'Men',
                        Type__c = 'DEFAULT'
                )
        };
        insert logsToInsert;
    }

    @IsTest
    static void testGetLogsByIds()
    {
        List<Log__c> logs = [SELECT Name, Type__c, Message__c FROM Log__c];
        List<Id> idsLogs = new List<Id>(new Map<Id, Log__c>([SELECT Id FROM Log__c]).keySet());

        List<Log__c> logsFromConManager = LogManager.getLogsByIds(idsLogs);

        system.assertEquals(logs,logsFromConManager);
    }

    @IsTest
    static void testDeleteLogs()
    {
        List<Id> idsLogs = new List<Id>(new Map<Id, Log__c>([SELECT Id FROM Log__c]).keySet());

        LogManager.deleteLogs(idsLogs);
        List<Id> idsLogsAfterDelete = new List<Id>(new Map<Id, Log__c>([SELECT Id FROM Log__c]).keySet());

        System.assertEquals(0, idsLogsAfterDelete.size());
    }

    @IsTest
    static void testCreateLogs(){
        LogManager.LogWrapper wrapper = new LogManager.LogWrapper();
        wrapper.message = 'Test Contact';
        wrapper.type = 'Created';

        List<Log__c> contactsFalseInsert = LogManager.createLogs(wrapper, 2, false);
        List<Log__c> contactsNull = [SELECT Id FROM Log__c WHERE Type__c = 'Created'];
        System.assertEquals(2, contactsFalseInsert.size());
        System.assertEquals(0, contactsNull.size());

        List<Log__c> contactsTrueInsert = LogManager.createLogs(wrapper, 2, true);
        List<Log__c> contactsWithInsert = [SELECT Id FROM Log__c WHERE Type__c = 'Created'];
        System.assertEquals(2, contactsTrueInsert.size());
        System.assertEquals(2, contactsWithInsert.size());

    }

    @IsTest
    static void testUpdateLogs(){

        List<Id> idsLogs = new List<Id>(new Map<Id, Log__c>([SELECT Id FROM Log__c]).keySet());

        LogManager.LogWrapper wrapper = new LogManager.LogWrapper();
        wrapper.message = 'Test Contact';
        wrapper.type = 'Created';

        List<Log__c> logsFalseUpdate = LogManager.updateLogs(idsLogs, wrapper, false);
        List<Log__c> logsNull = [SELECT Id FROM Log__c WHERE Type__c = 'Created'];
        System.assertEquals(3, logsFalseUpdate.size());
        System.assertEquals(0, logsNull.size());

        List<Log__c> logsTrueUpdate = LogManager.updateLogs(idsLogs, wrapper, true);
        List<Log__c> logsWithUpdate = [SELECT Id FROM Log__c WHERE Type__c = 'Created'];
        System.assertEquals(3, logsTrueUpdate.size());
        System.assertEquals(3, logsWithUpdate.size());
    }
}