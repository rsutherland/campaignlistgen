@isTest
private class ctlrCampaignListGenerator_Tests {
	static testmethod void test1(){
		Campaign c = new Campaign();
		c.name = 'TESTCOVERAGE1';
		c.IsActive = true;
		insert c;
		system.assertnotequals(null,c.id);
		
		Campaign c2 = new Campaign();
		c2.name = 'TESTCOVERAGE2';
		c2.IsActive = true;
		insert c2;
		system.assertnotequals(null,c2.id);
		
		Campaign_List_Generation__c clg = new Campaign_List_Generation__c();
		clg.Campaign__c = c.id;
		insert clg;
		system.assertnotequals(null,clg.id);
		
		test.startTest();
		test.setCurrentPage(new apexpages.pagereference('/apex/vfCampaignListGenerator'));
		apexpages.currentPage().getParameters().put('id',clg.id);
		apexpages.Standardcontroller con = new apexpages.Standardcontroller(clg);
		ctlrCampaignListGenerator ctlr = new ctlrCampaignListGenerator(con);
		
		//ctlr.newRecord();
		
		ctlr.accFld = 'AccountId';
		ctlr.accOp = 'Starts With';
		ctlr.accVal = 'test';
		ctlr.addAccQueryItem();
		list<Campaign_List_Generation_Criteria__c> clgCr = [select id from Campaign_List_Generation_Criteria__c where Campaign_List_Generation__c = : clg.id];
		system.assertequals(1,clgCr.size());
		string w = ctlr.getWhereClause();
		
		ctlr.accFld = 'name';
		ctlr.accOp = 'Equals';
		ctlr.accVal = 'test';
		ctlr.addAccQueryItem();
		clgCr = [select id from Campaign_List_Generation_Criteria__c where Campaign_List_Generation__c = : clg.id];
		system.assertequals(2,ctlr.getQueryItems().size());
		w = ctlr.getWhereClause();
		
		ctlr.deleteId = clgCr[0].id;
		ctlr.deleteCriteria();
		clgCr = [select id from Campaign_List_Generation_Criteria__c where Campaign_List_Generation__c = : clg.id];
		system.assertequals(1,clgCr.size());
		
		Campaign_List_Additional_Campaigns__c ac = new Campaign_List_Additional_Campaigns__c();
		ac.Campaign__c = c2.id;
		ac.Campaign_List_Generation__c = clg.id;
		ac.Percentage__c = 50;
		insert(ac);
		system.assertnotequals(null,ac.id);
		system.assertequals(1,ctlr.getCampaigns().size());
		clg.Record_Distribution__c = 'Percentage';
		clg.Percentage__c = 50;
		update(clg);
		
		CLG_App_Settings__c cas = new CLG_App_Settings__c();
		cas.name='CampaignList_SOQL_9999';
		cas.Value__c = 'id != null';
		insert cas;
		ctlr.generateList();
		
		ctlr.deleteCampaignId = ac.id;
		ctlr.deleteCampaign();
		
		system.assertequals(0,ctlr.getCampaigns().size());
		
		test.stopTest();
	}
	
	
	static testmethod void test2(){
		Campaign c = new Campaign();
		c.name = 'TESTCOVERAGE1';
		c.IsActive = true;
		insert c;
		system.assertnotequals(null,c.id);
		
		Campaign_List_Generation__c clg = new Campaign_List_Generation__c();
		clg.Campaign__c = c.id;
		insert clg;
		system.assertnotequals(null,clg.id);
		
		test.startTest();
		apexpages.Standardcontroller con = new apexpages.Standardcontroller(clg);
		ctlrCampaignListGenerator ctlr = new ctlrCampaignListGenerator(con);
		ctlr.accFld = 'name';
		ctlr.accOp = 'Contains';
		ctlr.accVal = 'smith';
		ctlr.addAccQueryItem();
		list<Campaign_List_Generation_Criteria__c> clgCr = [select id from Campaign_List_Generation_Criteria__c where Campaign_List_Generation__c = : clg.id];
		system.assertequals(1,clgCr.size());
		string w = ctlr.getWhereClause();
		
		ctlr.accFld = 'Department';
		ctlr.accOp = 'Greater Than';
		ctlr.accVal = '0';
		ctlr.addAccQueryItem();
		clgCr = [select id from Campaign_List_Generation_Criteria__c where Campaign_List_Generation__c = : clg.id];
		system.assertequals(2,clgCr.size());
		w = ctlr.getWhereClause();
		
		ctlr.deleteId = clgCr[0].id;
		ctlr.deleteCriteria();
		clgCr = [select id from Campaign_List_Generation_Criteria__c where Campaign_List_Generation__c = : clg.id];
		system.assertequals(1,clgCr.size());
		test.stopTest();
	}
	static testmethod void test3(){
		Campaign c = new Campaign();
		c.name = 'TESTCOVERAGE1';
		c.IsActive = true;
		insert c;
		system.assertnotequals(null,c.id);
		
		Campaign_List_Generation__c clg = new Campaign_List_Generation__c();
		clg.Campaign__c = c.id;
		insert clg;
		system.assertnotequals(null,clg.id);
		
		test.startTest();
		apexpages.Standardcontroller con = new apexpages.Standardcontroller(clg);
		ctlrCampaignListGenerator ctlr = new ctlrCampaignListGenerator(con);
		ctlr.accFld = 'donotcall';
		ctlr.accOp = 'Equals';
		ctlr.accVal = 'true';
		ctlr.addAccQueryItem();
		list<Campaign_List_Generation_Criteria__c> clgCr = [select id from Campaign_List_Generation_Criteria__c where Campaign_List_Generation__c = : clg.id];
		system.assertequals(1,clgCr.size());
		string w = ctlr.getWhereClause();
		
		ctlr.accFld = 'Department';
		ctlr.accOp = 'In Range';
		ctlr.accVal = 'a,b,c';
		ctlr.addAccQueryItem();
		clgCr = [select id from Campaign_List_Generation_Criteria__c where Campaign_List_Generation__c = : clg.id];
		system.assertequals(2,clgCr.size());
		w = ctlr.getWhereClause();
		
		ctlr.deleteId = clgCr[0].id;
		ctlr.deleteCriteria();
		clgCr = [select id from Campaign_List_Generation_Criteria__c where Campaign_List_Generation__c = : clg.id];
		system.assertequals(1,clgCr.size());
		
		test.stopTest();
	}
	
	static testmethod void test5(){
		Campaign c = new Campaign();
		c.name = 'TESTCOVERAGE1';
		c.IsActive = true;
		insert c;
		system.assertnotequals(null,c.id);
		
		Campaign_List_Generation__c clg = new Campaign_List_Generation__c();
		clg.Campaign__c = c.id;
		insert clg;
		system.assertnotequals(null,clg.id);
		
		
		apexpages.Standardcontroller con = new apexpages.Standardcontroller(clg);
		ctlrCampaignListGenerator ctlr = new ctlrCampaignListGenerator(con);
		ctlr.accFld = 'donotcall';
		ctlr.accOp = 'Equals';
		ctlr.accVal = 'true';
		ctlr.addAccQueryItem();
		list<Campaign_List_Generation_Criteria__c> clgCr = [select id from Campaign_List_Generation_Criteria__c where Campaign_List_Generation__c = : clg.id];
		system.assertequals(1,clgCr.size());
		string w = ctlr.getWhereClause();
		
		ctlr.accFld = 'name';
		ctlr.accOp = 'Not In Range';
		ctlr.accVal = 'a,b,c';
		ctlr.addAccQueryItem();
		clgCr = [select id from Campaign_List_Generation_Criteria__c where Campaign_List_Generation__c = : clg.id];
		system.assertequals(2,clgCr.size());
		w = ctlr.getWhereClause();
		
		
		apexpages.Standardcontroller con2 = new apexpages.Standardcontroller(clg);
		ctlrCampaignListCopy ctlr2 = new ctlrCampaignListCopy(con2);
		ctlr2.copy();
	}
	
	static testmethod void test6(){
		Campaign c = new Campaign();
		c.name = 'TESTCOVERAGE1';
		c.IsActive = true;
		insert c;
		system.assertnotequals(null,c.id);
		
		Campaign c2 = new Campaign();
		c2.name = 'TESTCOVERAGE2';
		c2.IsActive = true;
		insert c2;
		system.assertnotequals(null,c2.id);
		
		Campaign_List_Generation__c clg = new Campaign_List_Generation__c();
		clg.Campaign__c = c.id;
		insert clg;
		system.assertnotequals(null,clg.id);
		
		Campaign_List_Additional_Campaigns__c ac = new Campaign_List_Additional_Campaigns__c();
		ac.Campaign__c = c2.id;
		ac.Campaign_List_Generation__c = clg.id;
		ac.Percentage__c = 50;
		insert(ac);
		system.assertnotequals(null,ac.id);
		
		clg.Percentage__c = 50;
		clg.Record_Distribution__c = 'Use Percentage';
		update clg;
		
		test.startTest();
		test.setCurrentPage(new apexpages.pagereference('/apex/vfCampaignListGenerator'));
		apexpages.currentPage().getParameters().put('id',clg.id);
		apexpages.Standardcontroller con = new apexpages.Standardcontroller(clg);
		ctlrCampaignListGenerator ctlr = new ctlrCampaignListGenerator(con);
		
		ctlr.accFld = 'LastName';
		ctlr.accOp = 'Equals';
		ctlr.accVal = 'test';
		ctlr.addAccQueryItem();
		list<Campaign_List_Generation_Criteria__c> clgCr = [select id from Campaign_List_Generation_Criteria__c where Campaign_List_Generation__c = : clg.id];
		system.assertequals(1,clgCr.size());
				
		ctlr.accFld = 'department';
		ctlr.accOp = 'Equals';
		ctlr.accVal = 'test';
		ctlr.addAccQueryItem();
		clgCr = [select id from Campaign_List_Generation_Criteria__c where Campaign_List_Generation__c = : clg.id];
		system.assertequals(2,ctlr.getQueryItems().size());
		
		CLG_App_Settings__c cas = new CLG_App_Settings__c();
		cas.name='CampaignList_SOQL_9999';
		cas.Value__c = 'id != null';
		insert cas;
			
		Account a = new Account();
		a.name = 'test1';
		insert a;
		system.assertnotequals(a.id,null);
		Contact ct = new Contact();
		ct.AccountId = a.id;
		ct.LastName = 'test';
		ct.Department='Test';
		ct.email='test@test.com';
		insert ct;
		system.assertnotequals(c.id,null);
		
		clsCampaignListGenerator b2 = new clsCampaignListGenerator();
		b2.listid=clg.id;
		b2.istest=true;
		list<sobject> so = new list<sobject>();
		so.add(ct);
		b2.start(null);
		b2.execute(null, so);
		
		database.executeBatch(b2);
		
		//test.setCurrentPage(new pagereference('/apex/vfUIBatchStatus'));
		//apexpages.currentPage().getParameters().put('id', clg.id);
		//Apexpages.standardcontroller contlr = new Apexpages.standardcontroller(clg); 
		//ctlrBatchStatus bstat = new ctlrBatchStatus(contlr);
		
		test.stopTest();
	}
	
	static testmethod void test7(){
		Campaign c = new Campaign();
		c.name = 'TESTCOVERAGE1';
		c.IsActive = true;
		insert c;
		system.assertnotequals(null,c.id);
		
		Campaign c2 = new Campaign();
		c2.name = 'TESTCOVERAGE2';
		c2.IsActive = true;
		insert c2;
		system.assertnotequals(null,c2.id);
		
		Campaign_List_Generation__c clg = new Campaign_List_Generation__c();
		clg.Campaign__c = c.id;
		insert clg;
		system.assertnotequals(null,clg.id);
		
		test.startTest();
		test.setCurrentPage(new apexpages.pagereference('/apex/vfCampaignListGenerator'));
		apexpages.currentPage().getParameters().put('id',clg.id);
		apexpages.Standardcontroller con = new apexpages.Standardcontroller(clg);
		ctlrCampaignListGenerator ctlr = new ctlrCampaignListGenerator(con);
		
		ctlr.accFld = 'LastName';
		ctlr.accOp = 'Equals';
		ctlr.accVal = 'test';
		ctlr.addAccQueryItem();
		list<Campaign_List_Generation_Criteria__c> clgCr = [select id from Campaign_List_Generation_Criteria__c where Campaign_List_Generation__c = : clg.id];
		system.assertequals(1,clgCr.size());
				
		ctlr.accFld = 'Department';
		ctlr.accOp = 'Equals';
		ctlr.accVal = 'test';
		ctlr.addAccQueryItem();
		clgCr = [select id from Campaign_List_Generation_Criteria__c where Campaign_List_Generation__c = : clg.id];
		system.assertequals(2,ctlr.getQueryItems().size());
		
		CLG_App_Settings__c cas = new CLG_App_Settings__c();
		cas.name='CampaignList_SOQL_9999';
		cas.Value__c = 'id != null';
		insert cas;
			
		Account a = new Account();
		a.name = 'test1';
		insert a;
		system.assertnotequals(a.id,null);
		Contact ct = new Contact();
		ct.AccountId = a.id;
		ct.LastName = 'test';
		ct.Department='Test';
		insert ct;
		system.assertnotequals(c.id,null);
		
		clsCampaignListGenerator b2 = new clsCampaignListGenerator();
		b2.listid=clg.id;
		b2.istest=true;
		list<sobject> so = new list<sobject>();
		so.add(ct);
		b2.start(null);
		b2.execute(null, so);
		
		database.executeBatch(b2);
		
		//test.setCurrentPage(new pagereference('/apex/vfUIBatchStatus'));
		//apexpages.currentPage().getParameters().put('id', clg.id);
		//Apexpages.standardcontroller contlr = new Apexpages.standardcontroller(clg); 
		//ctlrBatchStatus bstat = new ctlrBatchStatus(contlr);
		
		test.stopTest();
	}
	static testmethod void test8(){
		Campaign c = new Campaign();
		c.name = 'TESTCOVERAGE1';
		c.IsActive = true;
		insert c;
		system.assertnotequals(null,c.id);
		test.startTest();
		
		Campaign_List_Generation__c clg = new Campaign_List_Generation__c();
		apexpages.Standardcontroller con = new apexpages.Standardcontroller(clg);
		ctlrCampaignListGenerator ctlr = new ctlrCampaignListGenerator(con);
		test.setCurrentPage(new pagereference('/apex/vfCampaignList_NewRecord?returl=' + c.id));
		ctlr.newRecord();
		
		list<Campaign_List_Generation__c> t = [select id from Campaign_List_Generation__c where campaign__c = : c.id];
		system.assertEquals(1,t.size());
		
		test.stopTest();
	}
	
	
}