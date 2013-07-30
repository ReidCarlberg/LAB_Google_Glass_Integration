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

        TimelineMessage timelineMsg = new TimelineMessage();
        timelineMsg.text =message;
        
        LAB_Google_API_Settings__c apiSettings = LAB_Google_API_Settings__c.getOrgDefaults();
        LAB_Google_Mirror_Settings__c userSettings = LAB_Google_Mirror_Settings__c.getInstance(ownerId);
        
        HttpRequest firstPost = new HttpRequest();
        firstPost.setEndpoint('https://www.googleapis.com/mirror/v1/timeline');
        firstPost.setMethod('POST');
        firstPost.setHeader('Authorization', 'Bearer ' + userSettings.access_token__c);
        firstPost.setBody(JSON.serialize(timelineMsg));
        firstPost.setHeader('Content-Type', 'application/json');
        
        HttpResponse res2 = new Http().send(firstPost);

        String mirrorResponse = res2.getBody();        
        System.debug(mirrorResponse);
    }

    class TimelineMessage {
        public String text { get; set; }
    }
}