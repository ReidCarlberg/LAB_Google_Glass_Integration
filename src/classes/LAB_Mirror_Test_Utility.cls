@isTest
public class LAB_Mirror_Test_Utility{
    /*
		useful when the settings need to exist, but we don't need them.
	*/
    public static void setupSettings() {
        LAB_Mirror_Test_Utility.getApiSettings();
        LAB_Mirror_Test_Utility.getUserSettings();
    }
    
    public static LAB_Google_API_Settings__c getApiSettings() {
    	LAB_Google_API_Settings__c apiSettings = new LAB_Google_API_Settings__c();
        apiSettings.client_id__c = 'mockclient';
        apiSettings.client_secret__c = 'mocksecret';
        apiSettings.redirect_uri__c = 'mockuri';
        apiSettings.scope__c = 'mockscope';
        apiSettings.SetupOwnerId = UserInfo.getOrganizationId();
        upsert apiSettings;       
        return apiSettings;
    }
    
    public static LAB_Google_Mirror_Settings__c getUserSettings() {
        LAB_Google_Mirror_Settings__c userSettings = new LAB_Google_Mirror_Settings__c();
     	userSettings.refresh_token__c = 'mockrefreshtoken';
        userSettings.access_token__c = 'mockaccesstoken';
        userSettings.SetupOwnerId = UserInfo.getUserId();
        upsert userSettings;
        return userSettings;
    }
}