@isTest
public class LAB_Mirror_Settings_Controller_Test{

    /*
		ensures that the basic premise of the test is working and that data is isolated.
	*/
    static testmethod void testSimple() {
        LAB_Mirror_Settings_Controller ctrl = new LAB_Mirror_Settings_Controller();
        System.assert(!ctrl.apiSettingsReady);
        System.assert(!ctrl.userSettingsReady);
    }
    
    static testmethod void testApiSettingsReady() {
     	LAB_Google_API_Settings__c apiSettings = LAB_Mirror_Test_Utility.getApiSettings();   
        LAB_Mirror_Settings_Controller ctrl = new LAB_Mirror_Settings_Controller();
        System.assert(ctrl.apiSettingsReady);
        System.assert(!ctrl.userSettingsReady);
    }

    static testmethod void testUserSettingsReady() {
     	LAB_Google_API_Settings__c apiSettings = LAB_Mirror_Test_Utility.getApiSettings();   
        LAB_Google_Mirror_Settings__c userSettings = LAB_Mirror_Test_Utility.getUserSettings();
        LAB_Mirror_Settings_Controller ctrl = new LAB_Mirror_Settings_Controller();
        System.assert(ctrl.apiSettingsReady);
        System.assert(ctrl.userSettingsReady);
    }    
    
    static testmethod void testAuthorizeApiUrl() {
     	LAB_Google_API_Settings__c apiSettings = LAB_Mirror_Test_Utility.getApiSettings();   
        LAB_Google_Mirror_Settings__c userSettings = LAB_Mirror_Test_Utility.getUserSettings();
        LAB_Mirror_Settings_Controller ctrl = new LAB_Mirror_Settings_Controller();
		PageReference newUrl = ctrl.authorizeApp();
        Map<String,String> params = newUrl.getParameters();
        System.assert(params.get('scope').equalsIgnoreCase('mockscope'));
        System.assert(params.get('redirect_uri').equalsIgnoreCase('mockuri'));
    }
        
}