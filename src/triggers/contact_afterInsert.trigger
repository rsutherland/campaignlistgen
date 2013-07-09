trigger contact_afterInsert on Contact (after insert) {
	for (Contact con : trigger.new){
		if(con.Title == 'CEO'){
			contactFutureCall.callHeroku(con.id);
		}
	}
}