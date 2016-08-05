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
			.then (result) ->
				res.ok result
			.catch res.serverError		