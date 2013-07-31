@isTest
//has to handle a three step request -- access token is expired, so request a new one, then send timeline request again
global class LAB_Mirror_Mock_TimelineTokenFails_Impl implements HTTPCalloutMock {
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
	        res.setStatusCode(401);   
			res.setBody('{"error":"error"}');            
            stepTwo = true;            
        } else {
            System.assert(false, 'Should never get here');
            System.assertEquals('https://www.googleapis.com/mirror/v1/timeline', req.getEndpoint());
	        res.setStatusCode(200);             
        }
        
        return res; 
    }
}