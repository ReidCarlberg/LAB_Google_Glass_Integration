@isTest
public class LAB_Mirror_Publisher_Test{

    /*
		simple success test
	*/
    static testmethod void testSimplePost() {
		LAB_Mirror_Test_Utility.setupSettings();
		Test.setMock(HttpCalloutMock.class, new LAB_Mirror_Mock_TimelinePost_Impl());   

        Test.startTest();
        Integer results = LAB_Mirror_Publisher.handleTimelinePost(UserInfo.getUserId(), 'SampleMessage');
        Test.stopTest();
        
        System.assertEquals(200, results);
    }        
    
    static testmethod void testSimplePost_Fails() {
		LAB_Mirror_Test_Utility.setupSettings();
		Test.setMock(HttpCalloutMock.class, new LAB_Mirror_Mock_TimelinePostFails_Impl());   
 
        Test.startTest();
        try {
            LAB_Mirror_Publisher.handlePublishMessageSync(UserInfo.getUserId(), 'SampleMessage');
            System.assert(false, 'Should have failed');
        } catch (LAB_Mirror_Exception e) {
			//do nothing
        }
        Test.stopTest();

    }     
    
    /* 
		test expired access token, renew access token, test again
	*/
    static testmethod void testRenewAccessToken() {
		LAB_Mirror_Test_Utility.setupSettings();
		Test.setMock(HttpCalloutMock.class, new LAB_Mirror_Mock_TimelineThenToken_Impl());   
        Test.startTest();
        LAB_Mirror_Publisher.handlePublishMessage(UserInfo.getUserId(), 'SampleMessage');
        Test.stopTest();
    }
    
    static testmethod void testRenewAccessToken_Fails() {
		LAB_Mirror_Test_Utility.setupSettings();
		Test.setMock(HttpCalloutMock.class, new LAB_Mirror_Mock_TimelineTokenFails_Impl());   
        Test.startTest();
        try {
	        LAB_Mirror_Publisher.handlePublishMessageSync(UserInfo.getUserId(), 'SampleMessage');
            System.assert(false, 'Should have thrown an error');
        } catch (LAB_Mirror_Exception e) {
            //do nothing
        }
        Test.stopTest();
        System.assertEquals(0,[Select count() From LAB_Mirror_Result__c]);
    }    
    
    /*
		test lead publishing -- single lead function
	*/
    static testmethod void testPublishLeads() {
        Lead lead1 = new Lead(firstName='Reid', lastName='Carlberg', company='Reid Co', phone='7738705554',ownerid=UserInfo.getUserId());
        
       	LAB_Mirror_Test_Utility.setupSettings();
     	
        Test.startTest();
		Test.setMock(HttpCalloutMock.class, new LAB_Mirror_Mock_TimelinePost_Impl());           
        LAB_Mirror_Publisher.publishLead(lead1);
        Test.stopTest();
        
        List<Lab_Mirror_Result__c> r = [Select Id, Name, Id__c From Lab_Mirror_Result__c];
        System.debug('**** results ' + r);
        
        System.assertEquals(1, [Select count() From LAB_Mirror_Result__c]);
    }
    
    static testmethod void testLeadTrigger() {
    	LAB_Mirror_Test_Utility.setupSettings();
        Test.startTest();
		Test.setMock(HttpCalloutMock.class, new LAB_Mirror_Mock_TimelinePost_Impl());                   
        Lead lead1 = new Lead(firstName='Reid', lastName='Carlberg', company='Reid Co', phone='7738705554',ownerid=UserInfo.getUserId());
        insert lead1;
        Test.stopTest();
        System.assertEquals(1, [Select count() From LAB_Mirror_Result__c]);
    }
}