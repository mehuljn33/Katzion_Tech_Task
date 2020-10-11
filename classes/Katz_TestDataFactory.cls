/**
 * @author : Mehul Jain
 * @date : 10/10/2020
 * @description : Test data setup class for all test classes
 **/

@IsTest
public with sharing class Katz_TestDataFactory {

    /**
     * @author  : Mehul Jain
     * @date : 10/10/2020
     * @description : Create Transaction data
     * @param transactionCount, numberOfRecords,performDML
     */
    public static List<Transaction__c> createTransactions(Integer transactionCount, Integer numberOfRecords, Boolean performDML) {
        List<Transaction__c> transactions = new List<Transaction__c>();
        Transaction__c objTransaction;
        for (Integer i = 0; i < numberOfRecords ; i++) {
            objTransaction = new Transaction__c();
            objTransaction.Transaction_Count__c = transactionCount;
            objTransaction.Total_Discount__c = 10;
            objTransaction.Total_Cost__c = 200;
            transactions.add(objTransaction);
        }

        if (performDML) {
            insert transactions;
        }

        return transactions;
    }

    /**
     * @author  : Mehul Jain
     * @date : 10/10/2020
     * @description : Create TransactionItem data
     * @param transactionId, numberOfRecords,performDML
     */
    public static List<TransactionItem__c> createTransactionItems (Id transactionId, Integer numberOfRecords, Boolean performDML) {
        List<TransactionItem__c> transactionItems = new List<TransactionItem__c>();
        TransactionItem__c transactionItem;
        for (Integer i = 0; i < numberOfRecords ; i++) {
            transactionItem = new TransactionItem__c();
            transactionItem.Item_Cost__c = 10;
            transactionItem.Transaction__c = transactionId;
            transactionItems.add(transactionItem);
        }

        if (performDML) {
            insert transactionItems;
        }

        return transactionItems;
    }
}