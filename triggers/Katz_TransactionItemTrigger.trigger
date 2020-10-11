/**
 * @author : Mehul Jain
 * @date : 10/10/2020
 * @description : Trigger on TransactionItem__c object to handle custom operations
 **/


trigger Katz_TransactionItemTrigger on TransactionItem__c (after insert) {

    //After Trigger scenarios
    if (Trigger.isAfter) {
        //After Insert Trigger scenarios
        if (Trigger.isInsert) {
            Katz_TransactionItemTriggerHandler.onAfterInsert(Trigger.new);
        }
    }
}