@isTest
//has to handle a three step request -- access token is expired, so request a new one, then send timeline request again
global class LAB_Mirror_Mock_TimelineThenToken_Impl implements HTTPCalloutMock {
    static Boolean stepOne = false;
    static Boolean stepTwo = false;

    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');

        if (!stepOne && !stepTwo) {
            System.assertEquals('https://www.googleapis.com/mirror/v1/timeline', req.getEndpoint());
	        res.setStatusCode(401);   
            res.setBody('{"error":"error"}');
            stepOne = true;
        } else if (stepOne && !stepTwo) {
            System.assertEquals('https://accounts.google.com/o/oauth2/token', req.getEndpoint());
	        res.setStatusCode(200);   
			res.setBody('{"access_token":"mock_access", "refresh_token":"mock_refresh", "id_token":"mock_id", "access_type":"mock_type", "expires_in":"3920"}');            
            stepTwo = true;            
        } else {
            System.assertEquals('https://www.googleapis.com/mirror/v1/timeline', req.getEndpoint());
	        res.setStatusCode(200);             
			res.setBody('{"kind":"mirror#timelineItem", "id":"mockid", "created":"2013-07-31T12:07:34.882Z", "updated":"2013-07-31T12:07:34.882Z", "etag":"\\"ZECOuWdXUAqVdpmYErDm2-91GmY/NVMWuR8LJyCKttsmne9R4K8n7YI\\"", "text": "New Lead: OauthCheck EarlyAm, Google, Inc., (234) 567-8900"}');            
        }
        
        return res; 
    }
}