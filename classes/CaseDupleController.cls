public with sharing class CaseDupleController {
    @AuraEnabled(Cacheable=true)
    public static List<Case> main(Id caseId){
        return setCaseDupleList(caseId);
    }
    
    public static List<Case> setCaseDupleList(Id caseId){
        Case thisCase = [SELECT Id, Subject, Reason, SuppliedEmail FROM Case WHERE Id =: caseId];
        List<Case> dupleCase = [SELECT ID, CaseNumber, Origin, 
                                SuppliedEmail, Status, Reason, Owner.Name
                                FROM Case 
                                WHERE (Subject =: thisCase.Subject 
                                 OR Reason =: thisCase.Reason 
                                 OR SuppliedEmail =: thisCase.SuppliedEmail) 
                                AND Status != 'Closed'
                               	AND ID !=: caseId];
        return dupleCase;
    }
}