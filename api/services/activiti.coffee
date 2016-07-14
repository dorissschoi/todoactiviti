Promise = require 'promise'
querystring = require 'querystring'

module.exports =
	#promise to get activiti running process instance
	#curl -X GET  --basic --user <>:<> http://localhost:8080/activiti-rest/service/runtime/tasks
	#promise to get activiti process definition
	#curl -X GET  --basic --user <>:<> http://localhost:8080/activiti-rest/service/repository/process-definitions
	getlist: (url) ->
		sails.log.info "url: #{url}"
				
		new Promise (resolve, reject) ->
			#sails.services.rest.basicget "#{url}?#{querystring.stringify(param)}", "#{username}", "#{password}"
			sails.services.rest.basicget "#{url}"
				.then (res) ->
					#sails.log.info "res: #{JSON.stringify(res.body)}"
					if !_.isUndefined res.body.data
						resolve res.body
					else
						reject new Error "Get Activiti - process definitions failed"
				.catch reject

	#promise to get activiti process instance
	#curl  -H "Content-Type: application/json" -X POST -d "{\"processDefinitionId\":\"$1\"}" ${url}/runtime/process-instances | python -mjson.tool				
	startprocessins: (processdefID) ->
		url = sails.config.activiti.url.startprocessins
		sails.log.info "url: #{url}"
		
		new Promise (resolve, reject) ->
			sails.services.rest.basicpost "#{url}", "#{processdefID}"
				.then (res) ->
					if res.statusCode == 201
						resolve res.body
					else
						reject new Error "Start Activiti - process instance failed"
				.catch reject								