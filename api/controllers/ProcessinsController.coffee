Promise = require 'promise'
actionUtil = require 'sails/lib/hooks/blueprints/actionUtil'

module.exports =
	find: (req, res) ->
		data = actionUtil.parseValues(req)
		activiti.req "get", "#{sails.config.activiti.url.processinslist}?includeProcessVariables=true"
			.then (task) ->
				ret = []
				
				_.each task.body.data, (record) ->
					myproc = _.union( 
						_.where(record.variables, {name: "createdBy", value: req.user.username}),
						_.where(record.variables, {name: "ao", value: req.user.username}),
						_.where(record.variables, {name: "ro", value: req.user.username}) 
					)
					nextHandler = _.findWhere(record.variables, {name: "nextHandler"})
					createdAt = _.findWhere(record.variables, {name: "createdAt"})
					
					if myproc.length > 0 && nextHandler.value != req.user.username
						_.extend record,
							nextHandler: nextHandler.value
							createdAt: createdAt.value
						ret.push record
							
				Promise.all ( _.map ret, (record) ->
					activiti.getTaskDetail(record))
				.then (result) ->
					val =
						count:		task.body.total
						results:	result
					res.ok(val)
			.catch res.serverError
			
	create: (req, res) ->
		data = actionUtil.parseValues(req)

		activiti.startProcIns data.processdefID, req.user
			.then res.ok				
			.catch res.serverError