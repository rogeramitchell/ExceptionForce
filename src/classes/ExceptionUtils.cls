global class ExceptionUtils {
    
    global static void handleException(Exception exceptionCaught, Boolean logToObject, Boolean logToSlack) {
        
        Exception__c exceptionStaged = new Exception__c();
        
        exceptionStaged.Cause__c = String.valueOf(exceptionCaught.getCause());
        exceptionStaged.Line_Number__c = exceptionCaught.getLineNumber();
        exceptionStaged.Message__c = exceptionCaught.getMessage();
        exceptionStaged.Stack_Trace_String__c = exceptionCaught.getStackTraceString();
        exceptionStaged.Type_Name__c = exceptionCaught.getTypeName();
        
        String exceptionCause = exceptionStaged.Cause__c;
        Decimal exceptionLineNumber = exceptionStaged.Line_Number__c;
        String exceptionMessage = exceptionStaged.Message__c;
        String exceptionStackTraceString = exceptionStaged.Stack_Trace_String__c;
        String exceptionTypeName = exceptionStaged.Type_Name__c;
        
        if(logToObject) {
            ExceptionUtils.logToObject(exceptionStaged);
        }
        
        if(logToSlack) {
            ExceptionUtils.logToSlack(exceptionCause, exceptionLineNumber, exceptionMessage, exceptionStackTraceString, exceptionTypeName);
        }
    }    
    
    private static void logToObject(Exception__c exceptionPassed) {

		List<Exception__c> exceptionsToInsert = new List<Exception__c >();

        exceptionsToInsert.add(exceptionPassed);
        insert exceptionsToInsert;
    }
    
    @future(callout=true) //need to pass a bunch of strings / integers to this fucker...
    private static void logToSlack(String exceptionCause, Decimal exceptionLineNumber, String exceptionMessage, String exceptionStackTraceString, String exceptionTypeName) {
		
        // Retrieving Slack details from custom setting
		List<Slack_Service__c> slackService = [SELECT Id, API_URL__c, Channel_ID__c, Icon_URL__c, Token__c, Username__c FROM Slack_Service__c LIMIT 1];
        
        String slackUrl = slackService[0].API_URL__c;
        String slackChannel = slackService[0].Channel_ID__c;
        String slackIconUrl = slackService[0].Icon_URL__c;
        String slackToken = slackService[0].Token__c;
        String slackUsername = slackService[0].Username__c;
        
        // Setting slackText based on details for Exception
        String slackText = '*_A new exception has been caught by ExceptionForce. See details below._* \n' + 
            '*Cause:* ' + exceptionCause + '\n' +
            '*Line Number:* ' + exceptionLineNumber + '\n' + 
            '*Message:* ' + exceptionMessage + '\n' + 
            '*Stack Trace String:* ' + exceptionStackTraceString + '\n' + 
            '*Type Name:* ' + exceptionTypeName;
        
		// Encode the strings that will be appended to the base URL
		slackIconUrl = EncodingUtil.urlEncode(slackIconUrl, 'UTF-8');
      	slackUsername = EncodingUtil.urlEncode(slackUsername, 'UTF-8');
      	slackText = EncodingUtil.urlEncode(slackText, 'UTF-8');
        
        // Setting Slack URL for endpoint
		String url = slackUrl +
            '?token=' + slackToken + 
            '&channel=' + slackChannel + 
            '&username=' + slackUsername +
            '&icon_url=' + slackIconUrl +
            '&text=' + slackText;
                
        Http h = new Http();
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('GET');
        
        HttpResponse res = h.send(req);
    }
}