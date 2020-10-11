/**
 * @author : Mehul Jain
 * @date : 10/09/2020
 * @description : Utility class to perform all the REST API call operations
 **/

public class Katz_RestUtility {
    public static HttpResponse response ;
    public static HttpRequest request;
    //Stores the unique identifier for each Integration log
    public static String integrationIdentifier;
    public static FINAL String POST_METHOD = 'POST';
    public static FINAL String CALLOUT_STRING = 'callout:';
    public static FINAL Integer SUCCESS_CODE = 200;
    public static FINAL String NULL_STRING = 'NULL';

    /**
     * @author  : Mehul Jain
     * @date : 10/09/2020
     * @description : Performs the 'actual' REST API call using the endpoints in parameter
     * @param requestBody, namedCredential
     */
    public static Boolean doCallout(String requestBody, String namedCredential) {
        //Prepare HTTP objects
        Http http = new Http();
        request = new HttpRequest();
        request.setEndpoint(CALLOUT_STRING + namedCredential);
        request.setMethod(POST_METHOD);
        request.setBody(requestBody);
        response = http.send(request);

        //For purely success cases, which have been parsed succesfully
        if (response != null && response.getStatusCode() == SUCCESS_CODE && parseResponse()) {
            //Insert Integration logs for the successful case
            createIntegrationLogs();
            return true;
        } else {
            //Insert Integration Logs for the failure case
            createIntegrationLogs();
            return false;
        }

    }

    /**
     * @author  : Mehul Jain
     * @date : 10/09/2020
     * @description : Placeholder for parsing the response
     * @param : none
     */
    public static Boolean parseResponse() {
        //Parsing logic for a successful response
        return true;
    }

    /**
     * @author  : Mehul Jain
     * @date : 10/09/2020
     * @description : Insert integration log for the API calls made
     * @param : none
     */
    public static void createIntegrationLogs() {
        //Create Integration logs here
        Integration_Logs__c integrationLog = new Integration_Logs__c();
        integrationLog.Identifier__c = integrationIdentifier;
        //Store the JSON request
        integrationLog.Request__c = request != null ? request.getBody() : NULL_STRING;
        //Store the JSON response
        integrationLog.Response__c = response != null ? response.getBody() : NULL_STRING;
        integrationLog.Integration_URL__c = request != null ? request.getEndpoint() : NULL_STRING;
        integrationLog.Response_code__c = response != null ? String.valueOf(response.getStatusCode()) : NULL_STRING;
        insert integrationLog;
    }

    /**
     * @author  : Mehul Jain
     * @date : 10/09/2020
     * @description : Wrapper classes for TransactionItemsAPI APIs begin here
     */
    public class TransactionItemsAPIWrapper {
        public TransactionItemsAPIkey keys;
        public TransactionItemsAPIvalue values;
    }

    public class TransactionItemsAPIkey {
        public String TransactionItemID;
        public TransactionItemsAPIkey(String transId) {
            //Trimming since the transactionItems API requires 15 digit Id
            this.TransactionItemID = transId.substring(0, 15);
        }
    }

    public class TransactionItemsAPIvalue {
        public String ItemCost;
        public String ItemName;
        public TransactionItemsAPIvalue(String itemName, Decimal itemCost) {
            this.ItemCost = itemCost != null ? String.valueOf(itemCost) : '0.00';
            this.ItemName = itemName;
        }
    }

    /**
     * @author  : Mehul Jain
     * @date : 10/09/2020
     * @description : Wrapper classes for TransactionsAPI APIs begin here
     */
    public class TransactionsAPIWrapper {
        public TransactionsAPIkey keys;
        public TransactionsAPIvalue values;
    }

    public class TransactionsAPIkey {
        public String TransactionID;
        public TransactionsAPIkey(String transId) {
            //Trimming since the transactions API requires 15 digit Id
            this.TransactionID = transId.substring(0, 15);
        }
    }
    public class TransactionsAPIvalue {
        public String TotalCost;
        public String TotalDiscount;
        public String TransactionDate;
        public String TotalCount;
    }
}