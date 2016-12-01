Promise = require 'bluebird'
actionUtil = require 'sails/lib/hooks/blueprints/actionUtil'


module.exports =
	find: (req, res) ->
		data = actionUtil.parseValues(req)
		activiti.instance.getHistory data.skip, data.procInsId 
			.then (result) ->
				res.ok(result)
			.catch res.serverError
	