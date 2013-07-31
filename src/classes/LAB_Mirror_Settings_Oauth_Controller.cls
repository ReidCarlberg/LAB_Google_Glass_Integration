public class LAB_Mirror_Settings_Oauth_Controller{
    
    public PageReference handleCallback() {
        
		LAB_Google_API_Settings__c apiSettings = LAB_Google_API_Settings__c.getOrgDefaults();
        LAB_Google_Mirror_Settings__c userSettings = LAB_Google_Mirror_Settings__c.getInstance(UserInfo.getUserId());
        
        String error = ApexPages.currentPage().getParameters().get('error');
        String code = ApexPages.currentPage().getParameters().get('code');

        if (error != null && error.length() > 0) {
            return Page.LAB_Error;
        }
        
        String postBody = 
			'code=' + code +
			'&client_id=' + apiSettings.client_id__c + 
			'&client_secret=' + apiSettings.client_secret__c + 
			'&redirect_uri=' + apiSettings.redirect_uri__c + 
			'&grant_type=authorization_code';
        
        HttpRequest req = new HttpRequest();
	    req.setEndpoint('https://accounts.google.com/o/oauth2/token');
	    req.setMethod('POST');
        req.setBody(postBody);

		HttpResponse res = new Http().send(req);
	    String response = res.getBody(); 
        
        System.debug(response);
        
        GoogleResponse r = (GoogleResponse) JSON.deserialize(response, LAB_Mirror_Settings_Oauth_Controller.GoogleResponse.class);
                
        System.debug(r);
        System.debug('refresh_token');
        System.debug(r.refresh_token);
        
        userSettings.refresh_token__c =r.refresh_token;
        userSettings.access_token__c = r.access_token;
        
        upsert userSettings;
        
        return Page.LAB_Mirror_Settings;
    }
    
    public class GoogleResponse {
        public String access_token {get; set; }
        public String refresh_token {get; set; }
        public String token_type { get; set; }
        public String expires_in { get; set; }
        public String id_token { get; set; }
    }    
    
    
}