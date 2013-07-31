@isTest
global class LAB_Mirror_Mock_TimelinePost_Impl implements HTTPCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        System.assertEquals('https://www.googleapis.com/mirror/v1/timeline', req.getEndpoint());
        System.assertEquals('POST', req.getMethod());
        System.assert(req.getHeader('Authorization').startsWith('Bearer'));
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"kind":"mirror#timelineItem", "id":"mockid", "created":"2013-07-31T12:07:34.882Z", "updated":"2013-07-31T12:07:34.882Z", "etag":"\\"ZECOuWdXUAqVdpmYErDm2-91GmY/NVMWuR8LJyCKttsmne9R4K8n7YI\\"", "text": "New Lead: OauthCheck EarlyAm, Google, Inc., (234) 567-8900"}');
        res.setStatusCode(200);
        return res;        
    }
}