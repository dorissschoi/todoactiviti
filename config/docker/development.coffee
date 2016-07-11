agent = require 'https-proxy-agent'

module.exports =
	hookTimeout:	400000
	

	oauth2:
		verifyURL:			"https://mob.myvnc.com/org/oauth2/verify/"
		tokenURL:			"https://mob.myvnc.com/org/oauth2/token/"
		scope:				["https://mob.myvnc.com/org/users"]
		
	
	http:
		opts:
			agent:	new agent("http://proxy1.scig.gov.hk:8080")

	activiti:
		url:
			processdef: "http://activiti-server:8080/activiti-rest/service/repository/process-definitions?category=http://www.activiti.org/processdef"
		username:	'kermit'
		password:	'kermit'

	promise:
		timeout:	10000 # ms

	models:
		connection: 'mongo'
		migrate:	'alter'
	
	connections:
		mongo:
			adapter:	'sails-mongo'
			driver:		'mongodb'
			url:		'mongodb://todo_mongo/todo'
		
	im:
		url: 		"https://mob.myvnc.com/im.app/api/msg"
		client:
			id:		'todomsgDEVAuth'
			secret: 'pass1234'
		user:
			id: 	'todoadmin'
			secret: 'pass1234'
		scope:  	[ "https://mob.myvnc.com/org/users", "https://mob.myvnc.com/mobile"]
		txt:		"one new task"
		digesttxt:	"Overdue task"
		xmpp:
			domain:	'mob.myvnc.com'
		adminjid:	"todoadmin@mob.myvnc.com"
		sendmsg:	false #dev not send

	log:
		level: 'silly'
