public with sharing class ctlrCampaignListCopy {
	string listId = '';
	Campaign_List_Generation__c obj;
	public ctlrCampaignListCopy(apexpages.standardController con){
		obj = (Campaign_List_Generation__c) con.getrecord();
	}
	
	public pagereference copy(){
		Campaign_List_Generation__c newObj = obj.clone();
		insert newObj;
		list<Campaign_List_Generation_Criteria__c> clist = [Select c.Value__c, 
																	c.Operator__c, 
																	c.Object__c, 
																	c.Id, 
																	c.Field_Type__c, 
																	c.Field_Label__c, 
																	c.Field_API_Name__c 
															From Campaign_List_Generation_Criteria__c c
															Where c.Campaign_List_Generation__c = : obj.Id];
		
		list<Campaign_List_Generation_Criteria__c> newclist = new list<Campaign_List_Generation_Criteria__c>();
		
		for (Campaign_List_Generation_Criteria__c c : clist){
			Campaign_List_Generation_Criteria__c newC = new Campaign_List_Generation_Criteria__c();
			newc.Value__c = c.Value__c;
			newc.Operator__c = c.Operator__c;
			newc.Object__c = c.Object__c;
			newc.Field_Type__c = c.Field_Type__c;
			newc.Field_Label__c = c.Field_Label__c;
			newc.Field_API_Name__c = c.Field_API_Name__c;
			newc.Campaign_List_Generation__c = newObj.id;
			newclist.add (newc);
		}
		insert(newclist);
		return new pagereference('/' + newObj.Id);
		
	}
	
}