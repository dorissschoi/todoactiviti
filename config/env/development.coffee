agent = require 'https-proxy-agent'
activitiurl = "http://172.22.0.3:8080/activiti-rest/service"

module.exports =
	hookTimeout:	400000
	
	port:			1337
	
	activiti:
		url:
			startprocessins: "#{activitiurl}/runtime/process-instances"
			processdeflist: "#{activitiurl}/repository/process-definitions?category=http://www.activiti.org/processdef"
			runninglist: "#{activitiurl}/runtime/tasks"
			
		username:	'kermit'
		password:	'kermit'
		
	oauth2:
		verifyURL:			"https://mob.myvnc.com/org/oauth2/verify/"
		tokenURL:			"https://mob.myvnc.com/org/oauth2/token/"
		scope:				["https://mob.myvnc.com/org/users"]
		
	http:
		opts:
			agent:	new agent("http://proxy1.scig.gov.hk:8080")

	promise:
		timeout:	10000 # ms

	models:
		connection: 'mongo'
		migrate:	'alter'
	
	connections:
		mongo:
			adapter:	'sails-mongo'
			driver:		'mongodb'
			url: 'mongodb://todosailsrw:pass1234@localhost/todosails' #dev
		
	im:
		url: 		"https://mob.myvnc.com/im.app/api/msg"
		client:
			id:		'todomsgDEVAuth'
			secret: 'password'
		user:
			id: 	'todoadmin'
			secret: 'password'
		scope:  	[ "https://mob.myvnc.com/org/users", "https://mob.myvnc.com/mobile"]
		txt:		"one new task"
		digesttxt:	"Overdue task"
		xmpp:
			domain:	'mob.myvnc.com'
		adminjid:	"todoadmin@mob.myvnc.com"
		sendmsg:	false #dev not send 
	
	log:
		level: 'silly'
		
			