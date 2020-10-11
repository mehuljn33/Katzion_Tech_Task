/**
 * @author : Mehul Jain
 * @date : 10/10/2020
 * @description : Queueable class for the Transactions API
 **/
public with sharing class Katz_QueueableTransactions implements Queueable, Database.AllowsCallouts {
    public final String NAMED_CREDENTIAL = 'DUMMY_API/Transactions';
    public Transaction__c objTransaction;
    public final String DATE_FORMAT_yyyy_MM_dd = 'yyyy-MM-dd';
    public final String DEFAULT_ZEROVALUE = '0.00';

    /**
     * @author  : Mehul Jain
     * @date : 10/10/2020
     * @description : Parametrized constructor to instantiate transaction for this process
     * @param objTransaction
     */
    public Katz_QueueableTransactions(Transaction__c objTransaction) {
        this.objTransaction = objTransaction;
    }

    /**
     * @author  : Mehul Jain
     * @date : 10/10/2020
     * @description : Call transactions API
     * @param QueueableContext
     */
    public void execute(QueueableContext context) {

        //Stores JSON request for transactionItem API
        String requestBody = getRequestForTransactionsAPI(this.objTransaction);
        //Set the unique identifier for integration logs
        Katz_RestUtility.integrationIdentifier = this.objTransaction != null ? String.valueOf(this.objTransaction.Id) : null;
        //Perform the transactions API callout
        Katz_RestUtility.doCallout(requestBody,NAMED_CREDENTIAL);
    }

    /**
     * @author  : Mehul Jain
     * @date : 10/10/2020
     * @description : Prepare the JSON request for Transactions API by fetching details for current transaction
     * @param none
     */
    public String getRequestForTransactionsAPI(Transaction__c objTransaction) {

        Katz_RestUtility.TransactionsAPIWrapper transactionsAPIWrapper = new Katz_RestUtility.TransactionsAPIWrapper();
        if (objTransaction != null) {
            //Map the values from Transaction record to the wrapper variables
            transactionsAPIWrapper.keys = new Katz_RestUtility.TransactionsAPIkey(objtransaction.Id);
            transactionsAPIWrapper.values = new Katz_RestUtility.TransactionsAPIvalue();
            transactionsAPIWrapper.values.TotalCost = objTransaction.Total_Cost__c != null ? String.valueOf(objTransaction.Total_Cost__c) : DEFAULT_ZEROVALUE;
            transactionsAPIWrapper.values.TotalDiscount = objTransaction.Total_Discount__c != null ? String.valueOf(objTransaction.Total_Discount__c) : DEFAULT_ZEROVALUE;
            transactionsAPIWrapper.values.TransactionDate = objTransaction.CreatedDate.format(DATE_FORMAT_yyyy_MM_dd) ;
            transactionsAPIWrapper.values.TotalCount = objTransaction.Transaction_Count__c != null ? String.valueOf(objTransaction.Transaction_Count__c) : DEFAULT_ZEROVALUE;
        }

        //Serialize the set of records and convert them to JSON
        return JSON.serializePretty(transactionsAPIWrapper);
    }


}