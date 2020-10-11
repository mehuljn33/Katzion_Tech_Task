/**
 * @author : Mehul Jain
 * @date : 10/10/2020
 * @description : TriggerHandler for TransactionItem__c object to redirect to helper for operations
 **/
public with sharing class Katz_TransactionItemTriggerHandler {

    /**
     * @author  : Mehul Jain
     * @date : 10/10/2020
     * @description : Iterates over the new list in after insert context to prepare lists for transferring to helper methods
     * @param transactionItems
     */
    public static void onAfterInsert(List<TransactionItem__c> transactionItems) {
        //Map all the individual items under parent transaction
        Map<Id, List<TransactionItem__c>> transactionItemsByTransactionIds = new Map<Id, List<TransactionItem__c>>();
        List<TransactionItem__c> tempTransactionItems ;

        //Iterate over the incoming transactionItems
        for (TransactionItem__c transactionItem : transactionItems) {
            //If the parent transaction is already registered, add the item under that record, else create new map instance for the transaction
            if (transactionItemsByTransactionIds.containsKey(transactionItem.Transaction__c) ) {
                tempTransactionItems = transactionItemsByTransactionIds.get(transactionItem.Transaction__c);
                tempTransactionItems.add(transactionItem);
                transactionItemsByTransactionIds.put(transactionItem.Transaction__c, tempTransactionItems);
            } else {
                transactionItemsByTransactionIds.put(transactionItem.Transaction__c, new List<TransactionItem__c>{transactionItem});
            }
        }

        //Check the requirements and if valid, then call the TransactionItem API
        if (!transactionItemsByTransactionIds.isEmpty()) {
            Katz_TransactionItemTriggerHelper.sendTransactionInformation(transactionItemsByTransactionIds);
        }
    }
}