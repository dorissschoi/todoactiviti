Promise = require 'promise'

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
			variables: [{name: 'createdBy', value: createdBy}]
		@req "post", sails.config.activiti.url.processinslist, data
			.then (res) ->
				if res.statusCode == 201
					return res.body
				else
					return new Error "Start activiti process instance failed"
			.catch (err) ->
				return err
				
	getProcInsVar: (procInsId, varName) ->
		@req "get", "#{sails.config.activiti.url.processinslist}/#{procInsId}/variables/#{varName}"
		
	getTask: (procInsId) ->
		@req "get", "#{sails.config.activiti.url.runninglist}?processInstanceId=#{procInsId}"
			.then (tasks) ->
				@task = tasks.body.data
				if _.isArray @task
					@task = @task[0]
				return @task
			.catch (err) ->
				return err
					