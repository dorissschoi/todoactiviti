Promise = require 'bluebird'
actionUtil = require 'sails/lib/hooks/blueprints/actionUtil'
activiticlient = require 'activiti-client'

module.exports =
	find: (req, res) ->
		data = actionUtil.parseValues(req)
		activiticlient.instance.historyTasklist data.skip, data.procInsId 
			.then (result) ->
				res.ok(result)
			.catch res.serverError
	