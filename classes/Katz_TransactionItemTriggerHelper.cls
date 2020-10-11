/**
 * @author : Mehul Jain
 * @date : 10/10/2020
 * @description : TriggerHelper for TransactionItem__c object to perform complex operations
 **/

public with sharing class Katz_TransactionItemTriggerHelper {
    /**
     * @author  : Mehul Jain
     * @date : 10/10/2020
     * @description : Check whether all the transaction items have entered in SF and send in a Queue for API call
     * @param transactionItemsByTransactionIds
     */
    public static void sendTransactionInformation(Map<Id, List<TransactionItem__c>> transactionItemsByTransactionIds) {
        //All qualified transaction ids will be stored here
        Set<Id> transactionIdsForCallout = new Set<Id>();
        //Count of New incoming transactionItems for each transaction
        Integer newTransactionItems;
        //Count of Pre-existing transactionItems records for each transaction
        Integer existingTransactionItems;
        //Threshold limit of transactionItems for each transaction
        Integer thresholdTransactionItems;

        //Create a Map of all parent transaction records by Ids
        Map<Id, Transaction__c> transactionsByIds = new Map<Id, Transaction__c>(
            [SELECT Id,Transaction_Count__c,Number_of_Transaction_Items_in_SF__c FROM Transaction__c WHERE Id IN:transactionItemsByTransactionIds.keySet()]
        );

        //Perform a check that which transactionItems will be required for hitting the transactionItem API
        for (Id transactionId : transactionItemsByTransactionIds.keySet()) {
            //These 3 variable assignments can be avoided for performance tuning but kept here for better readability
            newTransactionItems = transactionItemsByTransactionIds.get(transactionId).size();
            existingTransactionItems = transactionsByIds.get(transactionId).Number_of_Transaction_Items_in_SF__c != null ? Integer.valueOf(transactionsByIds.get(transactionId).Number_of_Transaction_Items_in_SF__c) : 0;
            thresholdTransactionItems = transactionsByIds.get(transactionId).Transaction_Count__c != null ? Integer.valueOf(transactionsByIds.get(transactionId).Transaction_Count__c) : 0;

            //If all transactionItems have entered in SF, add the parent transaction to the qualified list
            if( (newTransactionItems + existingTransactionItems == thresholdTransactionItems) && !transactionIdsForCallout.contains(transactionId)) {
                transactionIdsForCallout.add(transactionId);
            }
        }

        //Send all qualified transactionIds in a Queue for performing a REST callout
        if (!transactionIdsForCallout.isEmpty()) {
            System.enqueueJob( new Katz_QueueableTransItems (transactionIdsForCallout) );
        }

    }
}