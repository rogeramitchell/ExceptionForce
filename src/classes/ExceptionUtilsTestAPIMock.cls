@isTest
global class ExceptionUtilsTestAPIMock {
    global class SuccessfulResponseMock implements HttpCalloutMock {
        
        global HttpResponse respond(HttpRequest req) {
            
            String body = 
            '{' +
    			'"ok": true,' +
            	'"channel": "C02ET4ZEV",' +
    			'"ts": "1434041185.000033",' + 
                '"message": {' +
                    '"text": "A new exception has been caught by ExceptionForce. See details below."' +
                    '"username": "Salesforce",' +
                    '"type": "message",' +
                    '"subtype": "bot_message",' +
                    '"ts": "1434041185.000033"' +
    			'}' +			
			'}';
            
            HttpResponse res = new HttpResponse();
            
            res.setBody(body);
            
            return res;
        }
    }
    
    global class NoToken implements HttpCalloutMock {
        
        global HttpResponse respond(HttpRequest req) {
            
            String body = 
                '{' +
    				'"ok": false,' +
				    '"error": "not_authed"' +
				'}';
            
            HttpResponse res = new HttpResponse();
            
            res.setBody(body);

            return res;
        }
    }
    
    global class ChannelInvalidOrMissing implements HttpCalloutMock {
        
        global HttpResponse respond(HttpRequest req) {
            
            String body = 
                '{' +
    				'"ok": false,' +
				    '"error": "channel_not_found"' +
				'}';
            
            HttpResponse res = new HttpResponse();
            
            res.setBody(body);

            return res;
        }
        
    }
}