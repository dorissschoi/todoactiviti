Promise = require 'bluebird'
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
		_.extend record,
			nextHandler: nextHandler.value
			createdAt: createdAt.value					
		#if myproc.length > 0 && nextHandler.value != myusername
		if myproc.length > 0
			_.extend record,
				includeMe: true
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
			.then (rst) ->
				if rst.statusCode == 201
					res.ok(rst.body) 
				else 
					res.notFound(rst.body)				
			.catch res.serverError

	getDiagram: (req, res) ->
		data = actionUtil.parseValues(req)
		activiti.getProcInsDiagram data.procInsId
			.then (stream) ->
				res.ok(stream.raw)
			.catch res.serverError