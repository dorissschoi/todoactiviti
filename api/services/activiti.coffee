Promise = require 'promise'
		
taskCompleted = (taskId, currHandler) ->
	data =
		action: 'complete'
		variables: [{name: 'currHandler', value: currHandler}]
	module.exports.req "post", "#{sails.config.activiti.url.runninglist}/#{taskId}", data
		.then (res) ->
			if res.statusCode == 200 then res.body else new Error res.statusCode
		.catch (err) ->
			sails.log.error err

module.exports =

	req: (method, url, data) ->
		opts = 
			headers:
				Authorization:	"Basic " + new Buffer("#{sails.config.activiti.username}:#{sails.config.activiti.password}").toString("base64")
				'Content-Type': 'application/json'
			json: true

		sails.services.rest[method] {}, url, opts, data
		
	startProcIns: (processdefID, createdBy) ->
		data = 
			processDefinitionId: processdefID
			variables: [{name: 'createdBy', value: createdBy.username}]
		@req "post", sails.config.activiti.url.processinslist, data
			.then (res) ->
				if res.statusCode == 201 then res.body else new Error res.statusCode
			.catch (err) ->
				sails.log.error err
	
	completeTask: (taskId, currHandler) ->
		taskCompleted taskId, currHandler
			.catch (err) ->
				sails.log.error err