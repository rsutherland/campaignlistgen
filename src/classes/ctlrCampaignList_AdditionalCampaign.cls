public with sharing class ctlrCampaignList_AdditionalCampaign {
	
	public Campaign_List_Additional_Campaigns__c c{get;set;}
	public ctlrCampaignList_AdditionalCampaign(apexpages.standardcontroller con){
		if (apexpages.currentPage().getparameters().get('id') != null){
			c = [select id, campaign__c, percentage__c from Campaign_List_Additional_Campaigns__c where id = : apexpages.currentPage().getparameters().get('id')];
		}else{
			c = new Campaign_List_Additional_Campaigns__c();
		}
		
	}
	
	public pagereference saveRecord(){
		try{
			if (apexpages.currentPage().getparameters().get('id') != null){
				update c;
			}else{
				c.Campaign_List_Generation__c = apexpages.currentPage().getparameters().get('parid');
				insert c;				
			}
			return new pagereference('/apex/submodalLoading?close=1');
		}
		catch(exception e){
			Apexpages.Message m = new apexpages.Message(ApexPages.Severity.INFO, e.getMessage());
			apexpages.addMessage(m);
			return null;
		}
	}
	
	public pagereference saveAndNew(){
		try{			
			if (apexpages.currentPage().getparameters().get('id') != null){
				update c;
			}else{
				c.Campaign_List_Generation__c = apexpages.currentPage().getparameters().get('parid');
				insert c;
			}
			c = new Campaign_List_Additional_Campaigns__c();
			c.Percentage__c = 0;
			return new pagereference('/apex/vfCampaignListAdditionalCampaign?parId=' + apexpages.currentPage().getparameters().get('parid'));
		}
		catch(exception e){
			Apexpages.Message m = new apexpages.Message(ApexPages.Severity.INFO, e.getMessage());
			apexpages.addMessage(m);
			return null;
		}
	}
	
	static testmethod void test_1(){
		Campaign c = new Campaign();
		c.name = 'TestCampaign';
		c.IsActive = true;
		insert c;
		system.assertnotequals(null,c.id);
		
		Campaign c2 = new Campaign();
		c2.name = 'TestAdditionalCampaign1';
		c2.IsActive = true;
		insert c2;
		system.assertnotequals(null,c2.id);
		
		Campaign_List_Generation__c clg = new Campaign_List_Generation__c();
		clg.Campaign__c = c.id;
		insert clg;
		system.assertnotequals(null,clg.id);
		
		Campaign_List_Additional_Campaigns__c clac = new Campaign_List_Additional_Campaigns__c();
		test.startTest();
		
		apexpages.standardcontroller con = new apexpages.standardcontroller(clac);
		test.setCurrentPage(new pagereference('vfCampaignListAdditionalCampaign'));
		apexpages.currentPage().getParameters().put('parid', clg.id);
		ctlrCampaignList_AdditionalCampaign ctlr = new ctlrCampaignList_AdditionalCampaign(con);
		ctlr.c.Campaign__c = c2.id;
		ctlr.saveAndNew();
		
		list<Campaign_List_Additional_Campaigns__c> lst = [select id from Campaign_List_Additional_Campaigns__c where Campaign_List_Generation__c = : clg.id];
		system.assertequals(1,lst.size());
		ctlr.saveRecord();
		
		test.stopTest();
		
	}
	static testmethod void test_2(){
		Campaign c = new Campaign();
		c.name = 'TestCampaign';
		c.IsActive = true;
		insert c;
		system.assertnotequals(null,c.id);
		
		Campaign c2 = new Campaign();
		c2.name = 'TestAdditionalCampaign1';
		c2.IsActive = true;
		insert c2;
		system.assertnotequals(null,c2.id);
		
		Campaign_List_Generation__c clg = new Campaign_List_Generation__c();
		clg.Campaign__c = c.id;
		insert clg;
		system.assertnotequals(null,clg.id);
		
		Campaign_List_Additional_Campaigns__c clac = new Campaign_List_Additional_Campaigns__c();
		test.startTest();
		
		apexpages.standardcontroller con = new apexpages.standardcontroller(clac);
		test.setCurrentPage(new pagereference('vfCampaignListAdditionalCampaign'));
		apexpages.currentPage().getParameters().put('parid', clg.id);
		ctlrCampaignList_AdditionalCampaign ctlr = new ctlrCampaignList_AdditionalCampaign(con);
		ctlr.c.Campaign__c = c2.id;		
		ctlr.saveRecord();
		system.assertnotequals(null,ctlr.c.id);
		
		string clacId = ctlr.c.id;
		con = new apexpages.standardcontroller(clac);
		test.setCurrentPage(new pagereference('vfCampaignListAdditionalCampaign'));
		apexpages.currentPage().getParameters().put('parid', clg.id);
		apexpages.currentPage().getParameters().put('id', clacId);
		ctlr = new ctlrCampaignList_AdditionalCampaign(con);
		ctlr.c.Campaign__c = c2.id;		
		ctlr.saveRecord();
		
		test.stopTest();
		
	}
	
	static testmethod void test_3(){
		Campaign c = new Campaign();
		c.name = 'TestCampaign';
		c.IsActive = true;
		insert c;
		system.assertnotequals(null,c.id);
		
		Campaign c2 = new Campaign();
		c2.name = 'TestAdditionalCampaign1';
		c2.IsActive = true;
		insert c2;
		system.assertnotequals(null,c2.id);
		
		Campaign_List_Generation__c clg = new Campaign_List_Generation__c();
		clg.Campaign__c = c.id;
		insert clg;
		system.assertnotequals(null,clg.id);
		
		Campaign_List_Additional_Campaigns__c clac = new Campaign_List_Additional_Campaigns__c();
		test.startTest();
		
		apexpages.standardcontroller con = new apexpages.standardcontroller(clac);
		test.setCurrentPage(new pagereference('vfCampaignListAdditionalCampaign'));
		apexpages.currentPage().getParameters().put('parid', clg.id);
		ctlrCampaignList_AdditionalCampaign ctlr = new ctlrCampaignList_AdditionalCampaign(con);
		ctlr.c.Campaign__c = c2.id;		
		ctlr.saveRecord();
		system.assertnotequals(null,ctlr.c.id);
		
		string clacId = ctlr.c.id;
		con = new apexpages.standardcontroller(clac);
		test.setCurrentPage(new pagereference('vfCampaignListAdditionalCampaign'));
		apexpages.currentPage().getParameters().put('parid', clg.id);
		apexpages.currentPage().getParameters().put('id', clacId);
		ctlr = new ctlrCampaignList_AdditionalCampaign(con);
		ctlr.c.Campaign__c = c2.id;		
		ctlr.saveAndNew();
		
		test.stopTest();
		
	}
}