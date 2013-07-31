public class LAB_Mirror_Publisher{
    
    static Integer renewTokenResult { get; set; }
    static TimelineResult result { get; set; }
    
    public static void publishLeads(List<Lead> newLeads) {
        if (newLeads.size() == 1) {
            LAB_Mirror_Publisher.publishLead(newLeads.get(0));
        } else if (newLeads.size() > 1) {
            //todo so terrible
            LAB_Mirror_Publisher.publishMessage(newLeads.get(0).ownerId, 'You have new leads: ' + newLeads.size());
        } 
    }
    
    public static void publishLead(Lead lead) {
    	String toPublish='New Lead: ' + lead.firstName + ' ' + lead.lastName + ', ' + lead.Company + ', ' + lead.Phone;
        LAB_Mirror_Publisher.publishMessage(lead.ownerId, toPublish);
    }
            
    public static void publishMessage(Id ownerId, String message) {
        LAB_Google_API_Settings__c apiSettings = LAB_Google_API_Settings__c.getOrgDefaults();
        LAB_Google_Mirror_Settings__c userSettings = LAB_Google_Mirror_Settings__c.getInstance(ownerId);
        
        if (apiSettings == null || apiSettings.client_id__c == null || userSettings == null || userSettings.access_token__c == null) {
            System.debug('no settings');
        } else {
            LAB_Mirror_Publisher.handlePublishMessage(ownerId, message);
        }
    }
    
    @future(callout=true)
        public static void handlePublishMessage(Id ownerId, String message) {
            try {
                LAB_Mirror_Publisher.handlePublishMessageSync(ownerId, message);
            } catch (LAB_Mirror_Exception e) {
                //do something
                System.debug('***** Exception ' + e);
                
            }
        }
    public static void handlePublishMessageSync(Id ownerId, String message) {        
        LAB_Google_API_Settings__c apiSettings = LAB_Google_API_Settings__c.getOrgDefaults();
        LAB_Google_Mirror_Settings__c userSettings = LAB_Google_Mirror_Settings__c.getInstance(ownerId);
        
        Integer postStatus = handleTimelinePost(userSettings.access_token__c, message);
        Boolean okToInsert = false;
        if (postStatus != 200) {
            if (postStatus == 401) {
                System.debug('attempting to get new access_token');
                String newAccessToken = handleTokenRefresh(apiSettings, userSettings); 
                if (renewTokenResult == 200) {
                    postStatus = handleTimelinePost(newAccessToken, message);
                    if (postStatus == 200) {
                        userSettings.access_token__c = newAccessToken;
                        update userSettings;
                        okToInsert = true;
                    } else {
                       System.debug('error -- refresh token didn\'t work.');
                       throw new LAB_Mirror_Exception('Access_Token refresh failed during timeline publish');
                    }
                } else {
                    throw new LAB_Mirror_Exception('Couldn\'t renew access token');
                } 
            } else {
                System.debug('other error ' + postStatus);
                throw new LAB_Mirror_Exception('Error during timeline post ' + postStatus);
            }
        } else {
            okToInsert = true;
        }

		System.debug('**** ok ' + okToInsert);        
        if (okToInsert) {
            System.debug('****' + result.toSobject());
            try {
                LAB_Mirror_Result__c r = result.toSobject();
	            insert r;
                System.debug('**** insert should have happened');
            } catch (Exception e) {
                System.debug('**** exception ' + e);
            }
        }


    }
    
    public static Integer handleTimelinePost(String access_token, String message) {
        
        TimelineMessage timelineMsg = new TimelineMessage();
        timelineMsg.text =message;        
        
        HttpRequest firstPost = new HttpRequest();
        firstPost.setEndpoint('https://www.googleapis.com/mirror/v1/timeline');
        firstPost.setMethod('POST');
        firstPost.setHeader('Authorization', 'Bearer ' + access_token);
        firstPost.setBody(JSON.serialize(timelineMsg));
        firstPost.setHeader('Content-Type', 'application/json');
        HttpResponse res2 = new Http().send(firstPost);        
        String mirrorResponse = res2.getBody();        
        System.debug(mirrorResponse);
        
        
        result = (TimelineResult) JSON.deserialize(mirrorResponse, LAB_Mirror_Publisher.TimelineResult.class);
        
        return res2.getStatusCode();
    }
    
    public static String handleTokenRefresh(LAB_Google_API_Settings__c apiSettings, LAB_Google_Mirror_Settings__c userSettings) {

    	String postBody = 
			'client_id=' + apiSettings.client_id__c + 
			'&client_secret=' + apiSettings.client_secret__c + 
			'&refresh_token=' + userSettings.refresh_token__c + 
			'&grant_type=refresh_token';
        
        HttpRequest req = new HttpRequest();
	    req.setEndpoint('https://accounts.google.com/o/oauth2/token');
	    req.setMethod('POST');
        req.setBody(postBody);

		HttpResponse res = new Http().send(req);
	    String response = res.getBody(); 
        
        renewTokenResult = res.getStatusCode();
        
        System.debug(response);
        
        LAB_Mirror_Settings_Oauth_Controller.GoogleResponse r = (LAB_Mirror_Settings_Oauth_Controller.GoogleResponse) JSON.deserialize(response, LAB_Mirror_Settings_Oauth_Controller.GoogleResponse.class);
                
    	return r.access_token;   
    }
    
    public class TimelineMessage {
        public String text { get; set; }
    }
    
    public class TimelineResult {
        public String kind { get; set; }
        public String id { get; set; }
        public Datetime created { get; set; }
        public Datetime updated { get; set; }
        public String etag { get; set; }
        public String text { get; set; }
        
        public LAB_Mirror_Result__c toSobject() {
         	LAB_Mirror_Result__c ret = new LAB_Mirror_Result__c();
            ret.kind__c = this.kind;
            ret.id__c = this.id;
            ret.created__c = this.created;
            ret.updated__c = this.updated;
            ret.etag__c = this.etag;
            ret.text__c = this.text;
            return ret;
        }
    }
}