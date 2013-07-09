global class clsCampaignListGenerator implements Database.Batchable<sObject>, Database.stateful{
	
	public boolean isTest = false;
	public string listId {get;set;}
	private string campaignId = '';
	private integer membersAdded = 0;
	private integer membersSelected = 0;
	private boolean hasTransactionFieldsInQuery = false;
	
	private Map<Id, Integer> campaignsMap = new Map<Id, Integer>();
	private List<String> campaignsList = new List<String>();
	private boolean useAutoDistribution = true; 
	private string soql = '';
	private string subQuerySoql = '';
	private integer campaignIndex = 0;
	private integer campaignRecordCount = 0;
	
	global  database.querylocator start(Database.BatchableContext bc){
		Campaign_List_Generation__c clist = [select id,Transaction_Fields__c, Record_Distribution__c, Percentage__c, campaign__c from Campaign_List_Generation__c where id = : listId];
		campaignId = clist.Campaign__c;
		List<Campaign_List_Additional_Campaigns__c> adCamp = [select Id, Campaign__c, Percentage__c from Campaign_List_Additional_Campaigns__c where Campaign_List_Generation__c = : listId];
		campaignsMap.put(campaignId, (integer.valueof(clist.percentage__c / 10)));
		campaignsList.add(campaignId);
		if(clist.Record_Distribution__c != 'Automatic'){
			useAutoDistribution = false;
		}
		for (Campaign_List_Additional_Campaigns__c c : adCamp){
			campaignsMap.put(c.campaign__c, (integer.valueof(c.percentage__c / 10)));
			campaignsList.add(c.campaign__c);
		}		
		
		//if (clist.Transaction_Fields__c > 0){
		//	hasTransactionFieldsInQuery = true;
		//	subQuerySoql = 'select account__r.id, account__r.personContactId from Sales_Data_Transaction_Detail__c where Account__c in ({SCOPE}) and account__r.personemail != null and account__r.personHasOptedOutOfEmail = false and account__r.Email_Indicator__pc != \'Hard Bounce\' and ';
		//}else{
			subQuerySoql = 'select id from contact where id in ({SCOPE}) and email != null and ' ;	
		//} 
		subQuerySoql = subQuerySoql + clsCampaignListSOQLGenerator.whereClause(listId);
		
		list<CLG_App_Settings__c> whereClause = [select id, value__c from CLG_App_Settings__c where name like 'CampaignList_SOQL_%'];
		if (whereClause.size() > 0){
			soql = 'select id from contact where ' ;
			for (CLG_App_Settings__c clause : whereClause){
				soql = soql + clause.value__c + ' and ';
			}
			soql = soql.substring(0,soql.length()-5);
		}else{
			soql = 'select id from contact' ;	
		}
		
		 
		
		if (isTest){
			soql = 'select id from contact limit 20'; 
		}
		return Database.getQueryLocator(soql); 
	}
	
	global void execute(Database.BatchableContext bc, sObject[] objects){
		
		string scopeId = '';
		for (sObject so : objects){
			scopeId = scopeId + '\'' + so.id + '\',';
		}
		scopeId = scopeId.substring(0, scopeId.length()-1);
		string batchSOQL = subQuerySoql.replace('{SCOPE}', scopeId);
		
		system.debug('\n\n SOQL: ' + SOQL);
		system.debug('\n\n batchSOQL: ' + batchSOQL);
		List<sObject> qso = Database.query(batchSOQL);
		
		List<CampaignMember> cm = new List<CampaignMember>();
		//integer currentIndex = 0;
		//integer currentRecordCount = 0;
		system.debug('\n\n' + soql);
		for (string s : campaignsList){
			system.debug('\n\n' + s + ' : ' + campaignsMap.get(s));
		}
		if(useAutoDistribution){
			for (sobject so : qso){
				membersSelected ++;
				string personContactId = '';
				if (hasTransactionFieldsInQuery){
					//Sales_Data_Transaction_Detail__c t = (Sales_Data_Transaction_Detail__c) so;
					//personContactId = t.account__r.personContactId;
				}else{
					Contact c = (Contact) so;
					personContactId = c.id;
				}
				CampaignMember m = new CampaignMember();
				m.CampaignId = campaignsList[campaignIndex];
				campaignIndex ++;
				if(campaignIndex > (campaignsList.size() - 1) ){
					campaignIndex = 0;
				}
				m.ContactId = personContactId;
				cm.add(m);
			}
		}else{	
			for (sobject so : qso){
				membersSelected ++;
				string personContactId = '';
				if (hasTransactionFieldsInQuery){
					//Sales_Data_Transaction_Detail__c t = (Sales_Data_Transaction_Detail__c) so;
					//personContactId = t.account__r.personContactId;
				}else{
					Contact c = (Contact) so;
					personContactId = c.id;
				}
				CampaignMember m = new CampaignMember();
				
				string camId = '';
				while(camId==''){
					integer percent =  campaignsMap.get(campaignsList[campaignIndex]);
					if (percent > 0 && campaignRecordCount < percent){
						camId = campaignsList[campaignIndex];
						campaignRecordCount++;
					}else{
						campaignIndex ++;
						campaignRecordCount = 0;
						if(campaignIndex > (campaignsList.size()-1) ){
							campaignIndex = 0;
						}						
					}
				}
				m.CampaignId = camid;
				m.ContactId = personContactId;
				cm.add(m);
			}
		}
		
		Database.Saveresult[] dsr = database.insert(cm, false);
		for(Database.Saveresult sr : dsr){
			if (sr.isSuccess()){
				membersAdded ++;
			}
		}
		Campaign_List_Generation__c clg = [select Id, Status__c, Memebers_Added__c, Members_Selected__c from Campaign_List_Generation__c where id = : listId];
		clg.Memebers_Added__c = membersAdded;
		clg.Members_Selected__c = membersSelected;
		clg.Status__c = 'In Progress';
		update(clg);
	}
		
	global void finish(Database.BatchableContext bc){
		/*Campaign_List_Generation__c clg = [select Id, createdbyid, Status__c, Memebers_Added__c, Members_Selected__c from Campaign_List_Generation__c where id = : listId];
		clg.Memebers_Added__c = membersAdded;
		clg.Members_Selected__c = membersSelected;
		clg.Status__c = 'Completed';
		update(clg);
		User u = [select FirstName, email from user where id = : clg.createdbyid];
       	List<string> toAddresses = new List<string>();
       	toAddresses.add(u.email);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		mail.setToAddresses(toAddresses);
		mail.setSenderDisplayName('Campaign List Generator');
		mail.setSubject('List generation completed');
		mail.setPlainTextBody('Hi ' + u.FirstName + ', your list has been generated. '+ membersSelected + ' selected and ' + membersAdded + ' members added.');
		Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });*/
	}
}