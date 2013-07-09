global class contactFutureCall {
	@future(callout=true)
	public static void callHeroku(string contactId){
		Contact con = [select id, Firstname, Lastname, email, Description from Contact where id = :contactId];
		HttpRequest req = new HttpRequest();
		req.setEndpoint('http://forceminihack.herokuapp.com');
		req.setMethod('POST');
		req.setHeader('Content-Type', 'application/json');
		req.setbody('{"firstName": "First","lastName": "Last","email": "example@email.com", "msg_type": "ceo alert"}');
		Http http = new Http();
		HTTPResponse res = http.send(req);
		//System.debug(res.getBody());
		con.Description = res.getBody();
		update(con);
	}
}