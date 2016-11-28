Promise = require 'promise'
actionUtil = require 'sails/lib/hooks/blueprints/actionUtil'
activiticlient = require 'activiti-client'

module.exports =
	find: (req, res) ->
		data = actionUtil.parseValues(req)
		activiticlient.definition.list data.skip
			.then (processdefList) ->
				sails.log.debug "rst: #{JSON.stringify processdefList}"
				res.ok(processdefList)
			.catch res.serverError
		
	getDiagram: (req, res) ->
		data = actionUtil.parseValues(req)
		activiticlient.definition.diagram data.deploymentId
			.then (stream) ->
				res.ok stream
			.catch res.serverError
					