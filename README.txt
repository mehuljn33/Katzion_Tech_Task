# Katzion_Tech_Task
1. The branch repo contains all the code written in order to complete the dev task
2. The code contains 1 Trigger, 1 handler class, 1 helper class, 2 queueable classes, 1 schedulable class, 1 Utility class, 1 Test data setup class, 1 Test Mock class, 1 Test class.
3. There are some modifications done to the schema which are as follows : 
  a. A new Roll up summary field "Number_of_Transaction_Items_in_SF__c" is created on the object Transaction__c.
  b. A new custom object with the API name "Integration_Logs__c" is created for tracking the integration logs.
  c. A dummy open source API was used for UI testing and hence, 1 named credential record "DUMMY_API" and 1 remote site setting record "Dummy_Rest" is created for enabling code use.
