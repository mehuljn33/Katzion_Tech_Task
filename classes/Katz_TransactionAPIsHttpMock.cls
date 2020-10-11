/**
 * @author : Mehul Jain
 * @date : 10/10/2020
 * @description : HttpMock class for preparing mock responses REST Apis
 **/

@isTest
global class Katz_TransactionAPIsHttpMock implements HttpCalloutMock{
    //Stores whether to send mock response for success or failure
    Public String context;

    /**
     * @author  : Mehul Jain
     * @date : 10/10/2020
     * @description : Parameterized constructor to toggle success and failure responses
     * @param context
     */
    public Katz_TransactionAPIsHttpMock(String context){
        this.context = context;
    }

    /**
     * @author  : Mehul Jain
     * @date : 10/10/2020
     * @description : Send mock responses to test class
     * @param HttpRequest
     */
    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response;
        if ( request.getEndpoint().contains('callout:DUMMY_API')) {
            System.assertEquals('POST', request.getMethod());
            response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');

            if (this.context == 'SUCCESS') {
                //Send success response
                response.setBody('{"message":"success"}');
                response.setStatusCode(200);
            } else if (this.context == 'FAIL') {
                //Send error response
                response.setBody('{"message":"failed"}');
                response.setStatusCode(500);
            }
        }
        return response;
    }
}