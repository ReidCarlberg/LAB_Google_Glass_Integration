@isTest
global class LAB_Mirror_Mock_TimelinePostFails_Impl implements HTTPCalloutMock{
    global HTTPResponse respond(HTTPRequest req) {        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"kind":"mirror#timelineItem", "id":"mockid", "created":"2013-07-31T12:07:34.882Z", "updated":"2013-07-31T12:07:34.882Z", "etag":"\\"ZECOuWdXUAqVdpmYErDm2-91GmY/NVMWuR8LJyCKttsmne9R4K8n7YI\\"", "text": "New Lead: OauthCheck EarlyAm, Google, Inc., (234) 567-8900"}');
        res.setStatusCode(500);
        return res;        
    }
}