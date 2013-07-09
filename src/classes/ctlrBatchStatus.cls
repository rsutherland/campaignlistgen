public class ctlrBatchStatus {
	
	public string status {get;set;}
	public string TotalJobItems{get;set;}
	public string JobItemsProcessed {get;set;}
	public string CreatedDate{get;set;}
	public string CompletedDate{get;set;}
	public string batchId{get;set;}
	
	public ctlrBatchStatus(apexpages.standardcontroller con){
		init();
	}
	public ctlrBatchStatus(){
		init();
	}
	
	public void init(){
		string clgid;
		if (apexpages.currentPage().getparameters().get('id')!=null){
			clgid = apexpages.currentPage().getparameters().get('id');
		}
		Campaign_List_Generation__c clg = [select batch_Id__c from Campaign_List_Generation__c 
											where id = : clgid];
		if (clg.batch_Id__c != ''){
			AsyncApexJob a = [Select a.TotalJobItems, a.Status, a.NumberOfErrors, a.MethodName, a.JobItemsProcessed, a.Id, a.CreatedDate, a.CompletedDate, a.ApexClass.Name, a.ApexClassId 
						  From AsyncApexJob a
						  where id = : clg.batch_Id__c];
			status = a.status;
			TotalJobItems = string.valueof(a.TotalJobItems);
			JobItemsProcessed = string.valueof(a.JobItemsProcessed);
			CreatedDate = string.valueof(a.CreatedDate);
			CompletedDate =  string.valueof(a.CompletedDate);
			batchId = a.id;
			if (status == 'Processing'){
				if(a.TotalJobItems > 0 ){
					decimal total=a.TotalJobItems;
                    decimal done = a.JobItemsProcessed;
                    decimal stat = (100 / total) * done;
                    status = status + ' : ' + string.valueof(stat.round(System.RoundingMode.UP)) + '%';  	
				}
			}
		}else{
			status = 'Not submitted';
		}
		
	}
}