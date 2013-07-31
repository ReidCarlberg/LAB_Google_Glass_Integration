public class LAB_Mirror_Publisher{
    
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
            //do nothing
            System.debug('no settings');
        } else {
            LAB_Mirror_Publisher.handlePublishMessage(ownerId, message);
        }
    }
    
    @future(callout=true)
    static void handlePublishMessage(Id ownerId, String message) {


        
        LAB_Google_API_Settings__c apiSettings = LAB_Google_API_Settings__c.getOrgDefaults();
        LAB_Google_Mirror_Settings__c userSettings = LAB_Google_Mirror_Settings__c.getInstance(ownerId);
        
        Integer postStatus = handleTimelinePost(userSettings.access_token__c, message);
        if (postStatus != 200) {
            if (postStatus == 400) {
                String newAccessToken = handleTokenRefresh(apiSettings, userSettings); 
                postStatus = handleTimelinePost(newAccessToken, message);
                if (postStatus != 200) {
                   System.debug('error -- refresh token didn\'t work.');
                    
                }
            } else {
                System.debug('other error ' + postStatus);
            }
        }


    }
    
    static Integer handleTimelinePost(String access_token, String message) {
        
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
        
        return res2.getStatusCode();
    }
    
    static String handleTokenRefresh(LAB_Google_API_Settings__c apiSettings, LAB_Google_Mirror_Settings__c userSettings) {

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
        
        System.debug(response);
        
        LAB_Mirror_Settings_Oauth_Controller.GoogleResponse r = (LAB_Mirror_Settings_Oauth_Controller.GoogleResponse) JSON.deserialize(response, LAB_Mirror_Settings_Oauth_Controller.GoogleResponse.class);
                
        userSettings.access_token__c = r.access_token;
        update userSettings;
        
    	return userSettings.access_token__c;   
    }
    
    class TimelineMessage {
        public String text { get; set; }
    }
}