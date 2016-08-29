serverurl = "http://10.30.224.82:8011/activiti-rest/service"

module.exports.activiti =
	
	url:
		processinslist: "#{serverurl}/runtime/process-instances"
		processdeflist: "#{serverurl}/repository/process-definitions?category=http://activiti.org/test&latest=true&sort=deploymentId&order=desc"
		runninglist: "#{serverurl}/runtime/tasks"
		queryinslist: "#{serverurl}/query/process-instances"
		deployment: (id) ->
			"#{serverurl}/repository/deployments/#{id}"
			
	username:	'kermit'
	password:	'kermit'
