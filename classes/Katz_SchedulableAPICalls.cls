/**
 * @author : Mehul Jain
 * @date : 10/10/2020
 * @description : Schedulable class that can be extended to handle multiple API calls
 **/

global class Katz_SchedulableAPICalls implements Schedulable{
    public Transaction__c objTransaction;
    //Class name can be later used to extend this scheduled class and dynamically call other APIs
    public String className;

    /**
     * @author  : Mehul Jain
     * @date : 10/10/2020
     * @description : Parametrized constructor to instantiate transaction for this process
     * @param transactionIds
     */
    public Katz_SchedulableAPICalls( Transaction__c objTransaction) {
        this.objTransaction = objTransaction;
        this.className = className;
    }

    /**
     * @author  : Mehul Jain
     * @date : 10/10/2020
     * @description : Schedulable execute method to call the transactions API Queue
     * @param SchedulableContext
     */
    public void execute(SchedulableContext schedulableContext){
        //Calls the Transaction API Queueable class (Can be extended to call other classes dynamically using callable interface)
        System.enqueueJob( new Katz_QueueableTransactions(this.objTransaction)) ;
    }
}