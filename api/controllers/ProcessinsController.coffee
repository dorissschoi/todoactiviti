Promise = require 'promise'
actionUtil = require 'sails/lib/hooks/blueprints/actionUtil'

module.exports =
	find: (req, res) ->
		activiti.req 'get', sails.config.activiti.url.runninglist
			.then (result) ->
				val =
					count:		result.body.total
					results:	result.body.data
				res.ok(val)
			.catch res.serverError
		
	create: (req, res) ->
		data = actionUtil.parseValues(req)
		
		activiti.startProcIns(data.processdefID, req.user)
			.then (procIns) ->
				activiti.getProcInsVar procIns.url, 'url'
					.then (procInsVari) ->												
						activiti.getTask procIns.id
							.then (task) ->							
								@task = 
									task: task.name	
									createdBy: req.user
									ownedBy: req.user
									url: procInsVari.body.value
								sails.models.todo.create @task
									.then res.ok				
									.catch res.serverError
							.catch res.serverError		
					.catch res.serverError			 
			.catch res.serverError		