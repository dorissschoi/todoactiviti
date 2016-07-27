serverurl = "http://localhost:8080/activiti-rest/service"

module.exports.activiti =
	
	url:
		startprocessins: "#{serverurl}/runtime/process-instances"
		processdeflist: "#{serverurl}/repository/process-definitions?category=http://www.activiti.org/processdef"
		runninglist: "#{serverurl}/runtime/tasks"
			
	username:	'kermit'
	password:	'kermit'
