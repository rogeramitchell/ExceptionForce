@isTest
public class ExceptionUtilsTest {
    
    public static Account accountFail;
    public static Account accountSuccess;
    public static Slack_Service__c slackAPI;
    
    public static Integer eListSize;
   	public static String eCause;
    public static Decimal eLineNumber;
    public static String eMessage;
    public static String eStackTraceString;
    public static String eTypeName;
    
    static{
        
        accountFail = new Account();
        accountSuccess = new Account(Name = 'Account 2');
        slackAPI = new Slack_Service__c(Name = 'Error Channel', Channel_ID__c = 'C12345678', Username__c = 'ErrorBot', Icon_URL__c = 'http://placehold.it/48x48', API_URL__c = 'https://slack.com/api/chat.postMessage');
        
    }
    
    static testMethod void testAccountInsertFailure() {
        
        try {
            insert accountFail;
        } catch(Exception e) {
            ExceptionUtils.handleException(e, true, false);
            
            eCause = String.valueOf(e.getCause());
            eLineNumber = e.getLineNumber();
            eMessage = e.getMessage();
            eStackTraceString = e.getStackTraceString();
            eTypeName = e.getTypeName();
        }        
        
        List<Exception__c> exceptionCreated = [SELECT Id, Name, Cause__c, Line_Number__c, Message__c, Stack_Trace_String__c, Type_Name__c FROM Exception__c];
        
        eListSize = exceptionCreated.size();
        System.assertEquals(eListSize, 1);
        
        System.assertEquals(eCause, exceptionCreated[0].Cause__c);
        System.assertEquals(eLineNumber, exceptionCreated[0].Line_Number__c);
        System.assertEquals(eMessage, exceptionCreated[0].Message__c);
        System.assertEquals(eStackTraceString, exceptionCreated[0].Stack_Trace_String__c);
        System.assertEquals(eTypeName, exceptionCreated[0].Type_Name__c);
        
    }
    
    static testMethod void testAccountInsertSuccess() {
        
        try {
            insert accountSuccess;
        } catch(Exception e) {
            ExceptionUtils.handleException(e, true, false);
            
            eCause = String.valueOf(e.getCause());
            eLineNumber = e.getLineNumber();
            eMessage = e.getMessage();
            eStackTraceString = e.getStackTraceString();
            eTypeName = e.getTypeName();
        }        
        
        List<Exception__c> exceptionCreated = [SELECT Id, Name, Cause__c, Line_Number__c, Message__c, Stack_Trace_String__c, Type_Name__c FROM Exception__c];
        
        eListSize = exceptionCreated.size();
        System.assertEquals(eListSize, 0);
        
    }
    
    static testMethod void testAccountInsertFailureSlackPost() {
        
        insert slackAPI;
        Test.setMock(HttpCalloutMock.class, new ExceptionUtilsTestAPIMock.SuccessfulResponseMock());
        
        Test.startTest();
            try {
                insert accountFail;
            } catch(Exception e) {
                ExceptionUtils.handleException(e, false, true);
                
                eCause = String.valueOf(e.getCause());
                eLineNumber = e.getLineNumber();
                eMessage = e.getMessage();
                eStackTraceString = e.getStackTraceString();
                eTypeName = e.getTypeName();
            } 
        Test.stopTest();
    }
}