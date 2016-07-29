serverurl = "http://localhost:8080/activiti-rest/service"

module.exports.activiti =
	
	url:
		processinslist: "#{serverurl}/runtime/process-instances"
		processdeflist: "#{serverurl}/repository/process-definitions?category=http://activiti.org/test&latest=true"
		runninglist: "#{serverurl}/runtime/tasks"
			
	username:	'kermit'
	password:	'kermit'
