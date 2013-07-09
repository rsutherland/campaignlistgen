global class clsCampaignListSOQLGenerator {
	public static string whereClause(string listId){
		Campaign_List_Generation__c clist = [select id,Transaction_Fields__c, campaign__c from Campaign_List_Generation__c where id = : listId];
		list<Campaign_List_Generation_Criteria__c> crList = [select id, Field_Type__c , Calculated_Operator__c, Object__c, Field_API_Name__c, Operator__c, Value__c, Calculated_Field_Type__c 
															 from Campaign_List_Generation_Criteria__c 
															 where Campaign_List_Generation__c = :  clist.id];
		list<String> whereClause = new List<String>();													 
		for (Campaign_List_Generation_Criteria__c c : crlist){ 
			string val = c.Value__c;
			if (c.Operator__c == 'Starts With'){
				val = val + '%';
			}else if (c.Operator__c == 'Contains' || c.Operator__c == 'Does Not Contain'){
				val = '%' + val + '%';
			}else if (c.Operator__c.contains ('In Range')){
				list<String> temp = val.split(','); 
				val = '';
				for (string s : temp){
					if (s != ''){
						if (c.Calculated_Field_Type__c == 'STRING'){ 
							val = val + '\'' + s + '\', ';
						}else{
							val = val + s + ', ';
						}
					}
				}
				if (val.length() > 0){
					val = val.substring(0, val.length()-2);
				}				
			}
			string fieldName = '';
			
			//if (clist.Transaction_Fields__c > 0 && c.Object__c =='Account'){
			//	fieldName = 'Account__r.' + c.Field_API_Name__c + ' '; 
			//}else{
				fieldName = c.Field_API_Name__c + ' ';
			//}
			if (c.Field_Type__c == 'REFERENCE'){
				fieldName = fieldname.replace('__c', '__r.name');	
			}
			if (c.Calculated_Field_Type__c == 'STRING'){
				if (c.Operator__c.contains ('In Range')){
					whereClause.add (fieldName + c.Calculated_Operator__c + '(' + val + ')');
				}else if(c.Operator__c.contains ('Does Not Contain')){
					whereClause.add ('( NOT ' + fieldName + c.Calculated_Operator__c + ' \'' + val + '\')');
				}else{
					whereClause.add(fieldName + c.Calculated_Operator__c + '\'' + val + '\'');
				}
			}else if (c.Calculated_Field_Type__c == 'DATE'){
				whereClause.add(fieldName + c.Calculated_Operator__c + val);
			}else if (c.Calculated_Field_Type__c == 'DATETIME'){
				//2012-04-13T00:00:00Z
				whereClause.add(fieldName + c.Calculated_Operator__c + val + 'T00:00:00Z');
			}else if (c.Calculated_Field_Type__c == 'NUMBER'){
				if (c.Operator__c.contains ( 'In Range')){
					whereClause.add (fieldName + c.Calculated_Operator__c + '(' + val + ')');
				}else{
					whereClause.add(fieldName + c.Calculated_Operator__c + val);
				}
			}else if (c.Calculated_Field_Type__c == 'BOOLEAN'){
				whereClause.add(fieldName + c.Calculated_Operator__c + val);
			}
		}
		string soql = '';
		for (string s : whereClause){
			soql = soql + s + ' and ' ;
		}
		if (soql != ''){
			soql = soql.substring(0, soql.length()-5);
		}
		
		return soql;
	}
}