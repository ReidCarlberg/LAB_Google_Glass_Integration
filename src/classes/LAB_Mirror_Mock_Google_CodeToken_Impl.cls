@isTest
global class LAB_Mirror_Mock_Google_CodeToken_Impl implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        System.assertEquals('https://accounts.google.com/o/oauth2/token', req.getEndpoint());
        System.assertEquals('POST', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"access_token":"mock_access", "refresh_token":"mock_refresh", "id_token":"mock_id", "access_type":"mock_type", "expires_in":"3920"}');
        res.setStatusCode(200);    
        
        return res;
    }
}