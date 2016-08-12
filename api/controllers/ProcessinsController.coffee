Promise = require 'promise'
actionUtil = require 'sails/lib/hooks/blueprints/actionUtil'

module.exports =
	find: (req, res) ->
		data = actionUtil.parseValues(req)
		if data.createdBy == "me"
			activiti.getMyProcIns(req.user.username)
				.then (task) ->
					Promise.all ( _.map task.body.data, (record) ->
						activiti.getTaskName(record))
					.then (result) ->
						val =
							count:		task.body.total
							results:	result
						res.ok(val)
				.catch res.serverError
		else	
			activiti.req "get", sails.config.activiti.url.runninglist
				.then (result) ->
					res.ok
						count:		result.body.total
						results:	result.body.data
				.catch res.serverError
		
	create: (req, res) ->
		data = actionUtil.parseValues(req)

		activiti.startProcIns data.processdefID, req.user
			.then res.ok				
			.catch res.serverError