Promise = require 'bluebird'
actionUtil = require 'sails/lib/hooks/blueprints/actionUtil'


module.exports =
	find: (req, res) ->
		data = actionUtil.parseValues(req)
		activiti.instance.historyTasklist data.procInsId, data.skip  
			.then (result) ->
				res.ok(result)
			.catch res.serverError
	