@isTest
public class LAB_Mirror_Settings_Oauth_Ctrl_Test{
    /*
		if we get an error, we need to end up on the error page.
	*/
    static testmethod void testSimpleError() {
    	LAB_Mirror_Test_Utility.setupSettings();
        ApexPages.currentPage().getParameters().put('error','random');
        LAB_Mirror_Settings_Oauth_Controller ctrl = new LAB_Mirror_Settings_Oauth_Controller();
        PageReference errorRef = ctrl.handleCallback();
        System.debug(errorRef.getUrl());
        System.assert(errorRef.getUrl().endsWith('lab_error'));
    }
    
    /* 
		now assume we get a code from google, and that we're ready to exchange that code for an access_token
		assume that we have an api settings, but not a user settings
	*/
    static testmethod void testSimpleCode() {
        LAB_Mirror_Test_Utility.getApiSettings();
        Test.setMock(HttpCalloutMock.class, new LAB_Mirror_Mock_Google_CodeToken_Impl());
        ApexPages.currentPage().getParameters().put('code','mock_code');
        LAB_Mirror_Settings_Oauth_Controller ctrl = new LAB_Mirror_Settings_Oauth_Controller();
        Test.startTest();
        PageReference pageRef = ctrl.handleCallback();
        Test.stopTest();
        LAB_Google_Mirror_Settings__c userSettings = LAB_Google_Mirror_Settings__c.getInstance(UserInfo.getUserId());
        System.assertEquals(userSettings.access_token__c, 'mock_access');
        System.assertEquals(userSettings.refresh_token__c, 'mock_refresh');        
        System.assert(pageRef.getUrl().endsWith('lab_mirror_settings'));
    }
    
    /* 
		assume that we have an api settings, and user settings
		now assume we get a code from google, and that we're ready to exchange that code for an access_token
		new access token should overwrite eristing
	*/
    static testmethod void testOverwriteCode() {
        LAB_Mirror_Test_Utility.getApiSettings();
        LAB_Google_Mirror_Settings__c userSettings = LAB_Mirror_Test_Utility.getUserSettings();
        System.assertEquals(userSettings.access_token__c, 'mockaccesstoken');
        Test.setMock(HttpCalloutMock.class, new LAB_Mirror_Mock_Google_CodeToken_Impl());
        ApexPages.currentPage().getParameters().put('code','mock_code');
        LAB_Mirror_Settings_Oauth_Controller ctrl = new LAB_Mirror_Settings_Oauth_Controller();
        Test.startTest();
        PageReference pageRef = ctrl.handleCallback();
        Test.stopTest();
        LAB_Google_Mirror_Settings__c newUserSettings = LAB_Google_Mirror_Settings__c.getInstance(UserInfo.getUserId());
        System.assertEquals(newUserSettings.access_token__c, 'mock_access');
        System.assertEquals(newUserSettings.refresh_token__c, 'mock_refresh');        
        System.assert(pageRef.getUrl().endsWith('lab_mirror_settings'));
    }    
    
}