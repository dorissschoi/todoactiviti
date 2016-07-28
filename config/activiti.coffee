serverurl = "http://localhost:8080/activiti-rest/service"

module.exports.activiti =
	
	url:
		startprocessins: "#{serverurl}/runtime/process-instances"
		processdeflist: "#{serverurl}/repository/process-definitions?category=ApplyeLeave"
		runninglist: "#{serverurl}/runtime/tasks"
			
	username:	'kermit'
	password:	'kermit'
