/* 
------------------------------------------------------------
// Name:		ctlrCampaignListGenerator
// Author: 		SFDC(R.Sutherland)
// Function:	
// History:		23/03/2012 Created
------------------------------------------------------------
 */
public class ctlrCampaignListGenerator {

	public List<SelectOption> accFldList {get;set;}
	//public List<SelectOption> trnFldList {get;set;}
	public List<SelectOption> Operator {get;set;}
	public List<SelectOption> campaign {get;set;}
	//public List<Campaign_List_Generation_Criteria__c> queryItems {get;set;}
	
	Public string accFld{get;set;} 
	//Public string trnFld{get;set;}
	Public string accOp{get;set;}
	//Public string trnOp{get;set;}
	Public string accVal{get;set;}
	//Public string trnVal{get;set;}
	public string deleteId {get;set;}
	public string deleteCampaignId {get;set;}
	
	Campaign_List_Generation__c obj;
	apexpages.standardController ctlr;

	public List<Campaign_List_Generation_Criteria__c> getQueryItems(){
		return [select id, name, Campaign_List_Generation__c, object__c, Field_Label__c, Field_API_Name__c, Operator__c, Value__c 
				from Campaign_List_Generation_Criteria__c 
				where Campaign_List_Generation__c = : obj.id] ;
	}
	
	public ctlrCampaignListGenerator(apexpages.standardController con){
		obj = (Campaign_List_Generation__c) con.getrecord();
		ctlr = con;
		List <CLG_App_Settings__c> bs = [select id , name from CLG_App_Settings__c where value__c = 'campaignListExcludeField'];
		Map<String, String> accExcludeMap = new Map<String,String>();
		//Map<String, String> trnExcludeMap = new Map<String,String>();
		system.debug('\n\n' + bs.size());
		for (CLG_App_Settings__c b : bs){
			string temp = b.name;
			temp = temp.toLowerCase();
			system.debug('\n\n' + temp);
			//if (temp.startsWith('acc.')){
				accExcludeMap.put(temp.replace('acc.', ''), temp.replace('acc.', ''));
			//}else{
			//	trnExcludeMap.put(temp.replace('trn.', ''), temp.replace('trn.', ''));
			//}
			
		}
		operator = new List<SelectOption>();
		accFldList = new List<SelectOption>();
		//trnFldList = new List<SelectOption>();
		campaign = new List<SelectOption>();
		List<Campaign> camList = [Select Id, Name from Campaign where isactive = true order by name];
		campaign.add(New SelectOption('<Choose A Campaign>', '<Choose A Campaign>'));
		for (Campaign c : camList){
			campaign.add(New SelectOption(c.Id,c.Name));
		
		}
		operator.add(New SelectOption('Equals', 'Equals'));
		operator.add(New SelectOption('Contains', 'Contains'));
		operator.add(New SelectOption('Does Not Contain', 'Does Not Contain'));
		operator.add(New SelectOption('Starts With', 'Starts With'));
		operator.add(New SelectOption('Not Equal', 'Not Equal'));
		operator.add(New SelectOption('Less Than', 'Less Than'));
		operator.add(New SelectOption('Greater Than', 'Greater Than'));
		operator.add(New SelectOption('In Range', 'In Range'));
		operator.add(New SelectOption('Not In Range', 'Not In Range'));
		
		accFldList.add(New SelectOption('', ''));
		Map<String, Schema.SObjectField> M = Schema.SObjectType.Contact.fields.getMap();
		for (String s : M.keyset()){
			if(!accExcludeMap.containsKey(s)){
				Schema.SObjectField f = M.get(s);
				Schema.Describefieldresult fr = f.getDescribe();
				accFldList.add(New SelectOption(s, fr.getLabel()));				
			}
		}
		accFldList = SortOptionList(accFldList);
		
		/*trnFldList.add(New SelectOption('', ''));
		Map<String, Schema.SObjectField> M2 = Schema.SObjectType.Task.fields.getMap();
		for (String s : M2.keyset()){
			if(!trnExcludeMap.containsKey(s)){
				Schema.SObjectField f2 = M2.get(s);
				Schema.Describefieldresult fr2 = f2.getDescribe();
				trnFldList.add(New SelectOption(s, fr2.getLabel()));
			}
		}
		
		trnFldList = SortOptionList(trnFldList);*/
	}
	
	Public List<Campaign_List_Additional_Campaigns__c> getCampaigns(){
		return [select id, campaign__c, campaign__r.name, percentage__c from Campaign_List_Additional_Campaigns__c where Campaign_List_Generation__c = : apexPages.currentPage().getparameters().get('id')];
		
	}
	
	/*public class memberCampaign{
		public string cId{get;set;}
		public string name{get;set;}
		public integer percentage{get;set;}
		
		public memberCampaign(string Id, string n, integer perc){
			cId = Id;
			name = n;
			percentage = perc;
		}
	}*/
	
	public pagereference deleteCampaign(){
		Campaign_List_Additional_Campaigns__c c = new Campaign_List_Additional_Campaigns__c(id=deleteCampaignId);
		delete c;
		return null;
	}
	
	public pagereference addAccQueryItem(){
		try{
			Map<String, Schema.SObjectField> M = Schema.SObjectType.Contact.fields.getMap();
			Schema.SObjectField f = M.get(accfld);
			Schema.Describefieldresult fr = f.getDescribe();
			
			Campaign_List_Generation_Criteria__c c = new Campaign_List_Generation_Criteria__c();
			c.Campaign_List_Generation__c = obj.Id;
			c.Field_API_Name__c = accfld;
			c.Field_Label__c = fr.getlabel();
			c.Operator__c = accop;
			c.value__c = accval;
			c.Field_Type__c = fr.getType().name();
			c.Object__c = 'Contact';
			insert (c);
			obj = (Campaign_List_Generation__c) ctlr.getrecord();
		}catch(exception e){
			Apexpages.Message m = new apexpages.Message(ApexPages.Severity.INFO, e.getmessage());
			apexpages.addMessage(m);
		}
		return null;
	}
	
	public string getWhereClause(){
		return clsCampaignListSOQLGenerator.whereClause(obj.Id);
	}
	
	
	/*public pagereference addTrnQueryItem(){
		try{
			Map<String, Schema.SObjectField> M = Schema.SObjectType.Task.fields.getMap();
			Schema.SObjectField f = M.get(trnfld);
			Schema.Describefieldresult fr = f.getDescribe();
			
			Campaign_List_Generation_Criteria__c c = new Campaign_List_Generation_Criteria__c();
			c.Campaign_List_Generation__c = obj.Id;
			c.Field_API_Name__c = trnfld;
			c.Field_Label__c = fr.getlabel();
			c.Operator__c = trnop;
			c.value__c = trnval;
			c.Field_Type__c = fr.getType().name();
			c.Object__c = 'Task';
			insert (c);
			obj = (Campaign_List_Generation__c) ctlr.getrecord();
		}catch(exception e){
			Apexpages.Message m = new apexpages.Message(ApexPages.Severity.INFO, e.getmessage());
			apexpages.addMessage(m);
		}
		return null;
	}*/
	
	public pagereference deleteCriteria(){
		Campaign_List_Generation_Criteria__c c = new Campaign_List_Generation_Criteria__c(Id=deleteId);
		delete (c);
		return null;
	}
	
	public pagereference checkStatus(){
		//list<CLG_App_Settings__c> apset = [select id, value__c from CLG_App_Settings__c where name='listgenpageoption'];
		if (obj.Status__c == 'New'){
			/*if(apset.size()>0){
				if(apset[0].Value__c == '1'){
					apexpages.currentPage().getParameters().put('b2','false');
					apexpages.currentPage().getParameters().put('b1','true');
				}else{
					apexpages.currentPage().getParameters().put('b2','true');
					apexpages.currentPage().getParameters().put('b1','false');
				}
			}else{
				apexpages.currentPage().getParameters().put('b2','false');
				apexpages.currentPage().getParameters().put('b1','true');
			}*/
			return null;
				
		}else{
			return new pagereference('/' + obj.id + '?nooverride=1');
		}
		
	}
	Public pagereference newRecord(){
		//list<CLG_App_Settings__c> apset = [select id, value__c from CLG_App_Settings__c where name='listgenpageoption'];
		
		Campaign_List_Generation__c clg = new Campaign_List_Generation__c();
		string temp = apexpages.currentPage().getParameters().get('retURL');
		temp=temp.replace('/','');
		clg.Campaign__c = temp;
		insert clg;
		//if(apset.size()>0){
		//	if(apset[0].Value__c == '1'){
		//		return new pagereference('/' + clg.id + '?b2=false&b1=true');
		//	}else{
		//		return new pagereference('/' + clg.id + '?b1=false&b2=true');
		//	}
		//}else{
			return new pagereference('/' + clg.id + '?b2=false&b1=true');
		//}
		
	}
	
	public pageReference generateList(){
		try{
			ctlr.save();
			list<AsyncApexJob> aaj = [Select a.Id From AsyncApexJob a where JobType = 'BatchApex' and status in ('Queued', 'Preparing', 'Processing')];
			if(aaj.size() < 5){
				integer bsize = 200;
				list<CLG_App_Settings__c> batchSize = [select id, value__c from CLG_App_Settings__c where name = 'CampaignList_batchSize'];
				if (batchSize.size() > 0){
					bsize = integer.valueof(batchsize[0].value__c);
				}
				clsCampaignListGenerator b = new clsCampaignListGenerator();
				b.listId = obj.id;
				string bid = database.executebatch(b,bsize);
				obj.Batch_Id__c = bid;
				obj.Status__c = 'Pending';
				update (obj);
				return new pagereference('/' + obj.id + '?nooverride=1');
			}else{
				Apexpages.Message m = new apexpages.Message(ApexPages.Severity.INFO, 'The system cannot submit this request at this point, please try again later.');
				apexpages.addMessage(m);
				/*list<CLG_App_Settings__c> apset = [select id, value__c from CLG_App_Settings__c where name='listgenpageoption'];
		
				if(apset.size()>0){
					if(apset[0].Value__c == '1'){
						apexpages.currentPage().getParameters().put('b2','false');
						apexpages.currentPage().getParameters().put('b1','true');
					}else{
						apexpages.currentPage().getParameters().put('b2','true');
						apexpages.currentPage().getParameters().put('b1','false');
					}
				}else{
					apexpages.currentPage().getParameters().put('b2','false');
					apexpages.currentPage().getParameters().put('b1','true');
				}*/
				return null;
			}
						
		}catch(exception e){
			return null;
		}
	}
	/*public class queryItem {
		public string fldName{get;set;}
		public string operator{get;set;}
		public string value{get;set;}
		 
		public queryItem(string f,string o,string v){
			fldName = f;
			operator = o;
			value = v;
		}
	}*/
	public static List<SelectOption> SortOptionList(List<SelectOption> ListToSort)
	{
		if(ListToSort == null || ListToSort.size() <= 1)
			return ListToSort;
			
		List<SelectOption> Less = new List<SelectOption>();
		List<SelectOption> Greater = new List<SelectOption>();
		integer pivot = 0;
		
		// save the pivot and remove it from the list
		SelectOption pivotValue = ListToSort[pivot];
		ListToSort.remove(pivot);
		
		for(SelectOption x : ListToSort)
		{
			if(x.getLabel() <= pivotValue.getLabel())
				Less.add(x);
			else if(x.getLabel() > pivotValue.getLabel()) Greater.add(x);	
		}
		List<SelectOption> returnList = new List<SelectOption> ();
		returnList.addAll(SortOptionList(Less));
		returnList.add(pivotValue);
		returnList.addAll(SortOptionList(Greater));
		return returnList; 
	}
	
	
	
}