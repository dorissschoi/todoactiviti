Promise = require 'promise'
actionUtil = require 'sails/lib/hooks/blueprints/actionUtil'

module.exports =
	find: (req, res) ->
		activiti.req 'get', sails.config.activiti.url.runninglist
			.then (result) ->
				res.ok
					count:		result.body.total
					results:	result.body.data
			.catch res.serverError
		
	create: (req, res) ->
		data = actionUtil.parseValues(req)
		
		activiti.startProcIns(data.processdefID, req.user)
			.then (procIns) ->
				Promise
					.all [ 
						activiti.getProcInsVar procIns.id, 'url'
						activiti.getTask procIns.id
					]
			.then (values) ->												
				sails.models.todo.create
					task: values[1].name	
					createdBy: req.user
					ownedBy: req.user
					url: values[0].body.value
			.then res.ok				
			.catch res.serverError		