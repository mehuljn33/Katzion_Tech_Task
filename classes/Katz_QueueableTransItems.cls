/**
 * @author : Mehul Jain
 * @date : 10/10/2020
 * @description : Queueable class for the TransactionItems API
 **/

public with sharing class Katz_QueueableTransItems implements Queueable, Database.AllowsCallouts {
    public final String NAMED_CREDENTIAL = 'DUMMY_API/TransactionItems';
    public Set<Id> transactionIds;
    public List<Transaction__c> transactionsWithItems;

    /**
     * @author  : Mehul Jain
     * @date : 10/10/2020
     * @description : Parametrized constructor to instantiate transaction for this process
     * @param transactionIds
     */
    public Katz_QueueableTransItems(Set<Id> transactionIds) {
        this.transactionIds = transactionIds;
        //Fetch all details required for the first and the second API calls
        this.transactionsWithItems = [
                SELECT Id, Name, CreatedDate, Total_Cost__c, Total_Discount__c, Transaction_Count__c, (
                        SELECT Id, Name, Item_Cost__c
                        FROM TransactionItem__r
                )
                FROM Transaction__c
                WHERE Id IN :transactionIds
        ];
    }

    /**
     * @author  : Mehul Jain
     * @date : 10/10/2020
     * @description : Call transactionItems API and if successful, call transactions API
     * @param QueueableContext
     */
    public void execute(QueueableContext context) {
        //Stores the next time for scheduled job execution
        String nextFireTime;
        //Stores JSON request for transactionItem API
        String requestBody = getRequestForTransItemsAPI();
        //Schedulable queue counter
        Integer schduledQueueCount = 0;

        //Set the unique identifier for integration logs
        Katz_RestUtility.integrationIdentifier = !this.transactionIds.isEmpty() ? String.valueOf(this.transactionIds) : null;

        //Perform the transactionItem API callout and if successful, proceed to call the transaction API
        if (Katz_RestUtility.doCallout(requestBody,NAMED_CREDENTIAL)) {

            //If there is only one parent transaction, chain the next queue here.
            //But if there are more, then create separate scheduled apex jobs which will queue the API calls since
            //chaining more than 1 job is not allowed and the transactionAPI doesn't support multiple transactions
            if (this.transactionsWithItems != null && this.transactionsWithItems.size() == 1) {

                //Chaining not supported in test classes, so need to skip if test is running
                if (!Test.isRunningTest()) {
                    System.enqueueJob(new Katz_QueueableTransactions(this.transactionsWithItems[0])) ;
                }
            } else if (this.transactionsWithItems != null) {

                //For all the parent transactions, fire a new scheduled job for calling the second API
                for (Transaction__c objTransaction : this.transactionsWithItems) {
                    schduledQueueCount ++;
                    //Create CRON expression for scheduling next job
                    nextFireTime = String.valueOf(Datetime.now().second() + 1) + ' ' + String.valueOf(Datetime.now().minute()) + ' ' + String.valueOf(Datetime.now().hour()) + ' * * ?';
                    System.schedule('Triggering TransactionAPI call in a new queue number '+schduledQueueCount+' at : ' + String.valueOf(Datetime.now()), nextFireTime, new Katz_SchedulableAPICalls(objTransaction));
                }
            }
        }
    }

    /**
     * @author  : Mehul Jain
     * @date : 10/10/2020
     * @description : Prepare the JSON request for TransactionItem API by fetching details for current transactions
     * @param none
     */
    public String getRequestForTransItemsAPI() {
        List<Katz_RestUtility.TransactionItemsAPIWrapper> transactionItemsAPIWrappers = new List<Katz_RestUtility.TransactionItemsAPIWrapper>();
        Katz_RestUtility.TransactionItemsAPIWrapper transactionItemsAPIWrapper;
        if (this.transactionsWithItems != null) {

            //Iterate over all the transactionItem records and populate wrapper correspondingly
            for (Transaction__c objTransaction : this.transactionsWithItems) {
                for (TransactionItem__c transactionItem : objTransaction.TransactionItem__r) {
                    transactionItemsAPIWrapper = new Katz_RestUtility.TransactionItemsAPIWrapper();
                    transactionItemsAPIWrapper.keys = new Katz_RestUtility.TransactionItemsAPIkey(transactionItem.Id);
                    transactionItemsAPIWrapper.values = new Katz_RestUtility.TransactionItemsAPIvalue(transactionItem.Name, transactionItem.Item_Cost__c);
                    transactionItemsAPIWrappers.add(transactionItemsAPIWrapper);
                }
            }
        }

        //Serialize the set of records and convert them to JSON
        return JSON.serializePretty(transactionItemsAPIWrappers);
    }

}