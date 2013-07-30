trigger LAB_Mirror_LeadTrigger on Lead (after insert) {
	LAB_Mirror_Publisher.publishLeads(trigger.new);
}