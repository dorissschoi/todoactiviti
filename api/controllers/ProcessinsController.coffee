Promise = require 'promise'
actionUtil = require 'sails/lib/hooks/blueprints/actionUtil'

module.exports =
	find: (req, res) ->
		data = actionUtil.parseValues(req)
		if data.createdBy == "me"
			Promise
				.all [ 
					activiti.getMyProcIns("createdBy", req.user.username)
					activiti.getMyProcIns("ro", req.user.username)
					activiti.getMyProcIns("ao", req.user.username)
				]
				.then (task) ->
					ret = []
					_.each task, (value) ->
						if value.body.size > 0
							_.each value.body.data, (record) ->
								ret.push record
					ret = _.uniq ret			
					Promise.all ( _.map ret, (record) ->
						activiti.getTaskDetail(record))
					.then (result) ->
						Promise.all ( _.map result, (record) ->
							activiti.getInsVar(record, "nextHandler"))
						.then (result) ->									
							val =
								count:		ret.length
								results:	result
							res.ok(val)
				.catch res.serverError
		else
			activiti.req "get", "#{sails.config.activiti.url.processinslist}?includeProcessVariables=true"
				.then (task) ->
					Promise.all ( _.map task.body.data, (record) ->
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