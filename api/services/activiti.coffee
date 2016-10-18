Promise = require 'bluebird'
		
module.exports =

	req: (method, url, data, opts) ->
		if _.isUndefined opts
			opts = 
				headers:
					Authorization:	"Basic " + new Buffer("#{sails.config.activiti.username}:#{sails.config.activiti.password}").toString("base64")
					'Content-Type': 'application/json'
				json: true

		sails.services.rest[method] {}, url, opts, data
		
	startProcIns: (processdefID, createdBy) ->
		data = 
			processDefinitionId: processdefID
			variables: [
				name: 'createdBy'
				value: createdBy.username
			, 
				name: 'nextHandler'
				value: createdBy.username
			,
				name: 'createdAt'
				type: 'date'
				value: new Date	
			]
		@req "post", sails.config.activiti.url.processinslist, data

	
	completeTask: (taskId, currHandler) ->
		data =
			action: 'complete'
			variables: [{name: 'completedBy', value: currHandler}]
		@req "post", "#{sails.config.activiti.url.runninglist}/#{taskId}", data
	
				
	getTaskDetail: (record) ->
		@req "get", "#{sails.config.activiti.url.runninglist}?processInstanceId=#{record.id}"
			.then (tasks) ->
				task = tasks.body.data
				if _.isArray task
					task = task[0]
				
				_.extend record,
					name: task.name	
					createTime: task.createTime
				return record
							
	delIns: (procInsId) ->
		@req "delete", "#{sails.config.activiti.url.processinslist}/#{procInsId}"
	

	getProcInsDiagram: (procInsId) ->
		opts = 
			headers:
				Authorization:	"Basic " + new Buffer("#{sails.config.activiti.username}:#{sails.config.activiti.password}").toString("base64")
				'Content-Type': 'image/png'
				
		@req "get", "#{sails.config.activiti.url.processinslist}/#{procInsId}/diagram", {}, opts

	getProcDefDiagram: (contentUrl) ->
		opts = 
			headers:
				Authorization:	"Basic " + new Buffer("#{sails.config.activiti.username}:#{sails.config.activiti.password}").toString("base64")
				'Content-Type': 'image/png'
				
		@req "get", contentUrl, {}, opts		