Promise = require 'promise'
actionUtil = require 'sails/lib/hooks/blueprints/actionUtil'


module.exports =
	find: (req, res) ->
		data = actionUtil.parseValues(req)
		activiti.definition.list data.skip
			.then (processdefList) ->
				sails.log.debug "rst: #{JSON.stringify processdefList}"
				res.ok(processdefList)
			.catch res.serverError
		
	getDiagram: (req, res) ->
		data = actionUtil.parseValues(req)
		activiti.definition.getDiagram data.deploymentId
			.then (stream) ->
				res.ok stream
			.catch res.serverError
					