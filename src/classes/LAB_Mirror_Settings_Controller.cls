public class LAB_Mirror_Settings_Controller{

    public final LAB_Google_API_Settings__c apiSettings { get; private set; }
    public final LAB_Google_Mirror_Settings__c userSettings { get; private set; }

    public final Boolean apiSettingsReady { get; private set; }
    public final Boolean userSettingsReady { get; private set; }
    
    public LAB_Mirror_Settings_Controller() {
    	apiSettings = LAB_Google_API_Settings__c.getOrgDefaults();
        userSettings = LAB_Google_Mirror_Settings__c.getInstance(UserInfo.getUserId());
        apiSettingsReady = apiSettings != null && apiSettings.client_id__c != null;
        userSettingsReady = userSettings != null && userSettings.refresh_token__c != null;
    }
    
    public PageReference authorizeApp() {
        String url = 'https://accounts.google.com/o/oauth2/auth?' + 
            'scope=' + apiSettings.scope__c +
            '&state=%2Fprofile' +
            '&redirect_uri=' + EncodingUtil.urlEncode(apiSettings.redirect_uri__c, 'UTF-8') +  
            '&response_type=code' +
            '&client_id=' + apiSettings.client_id__c + 
            '&access_type=offline' +
            '&approval_prompt=force';
            
    	return new PageReference(url);  
    }
    
}