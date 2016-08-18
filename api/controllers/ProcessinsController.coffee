Promise = require 'promise'
actionUtil = require 'sails/lib/hooks/blueprints/actionUtil'

taskFilter = (task, myusername) ->
	ret = []
	_.each task.body.data, (record) ->
		myproc = _.union( 
			_.where(record.variables, {name: "createdBy", value: myusername}),
			_.where(record.variables, {name: "ao", value: myusername}),
			_.where(record.variables, {name: "ro", value: myusername}) 
		)
		nextHandler = _.findWhere(record.variables, {name: "nextHandler"})
		createdAt = _.findWhere(record.variables, {name: "createdAt"})
					
		if myproc.length > 0 && nextHandler.value != myusername
			_.extend record,
				nextHandler: nextHandler.value
				createdAt: createdAt.value
			ret.push record
	return ret
	
module.exports =
	find: (req, res) ->
		data = actionUtil.parseValues(req)
		activiti.req "get", "#{sails.config.activiti.url.processinslist}?includeProcessVariables=true&start=#{data.skip}"
			.then (task) ->
				ret = taskFilter task, req.user.username
							
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