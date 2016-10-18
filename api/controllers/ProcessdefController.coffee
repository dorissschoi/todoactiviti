Promise = require 'promise'
actionUtil = require 'sails/lib/hooks/blueprints/actionUtil'

getDeploymentDetails = (procDef) ->
	activiti.req 'get', sails.config.activiti.url.deployment procDef.deploymentId
		.then (result) ->
			procDef.deploymentDetails = result.body
			return procDef
		.catch (err) ->
			sails.log.error err 			

module.exports =
	find: (req, res) ->
		data = actionUtil.parseValues(req)
		activiti.req "get", "#{sails.config.activiti.url.processdeflist}&start=#{data.skip}"
		#activiti.req 'get', sails.config.activiti.url.processdeflist
			.then (processdefList) ->
				Promise.all _.map processdefList.body.data, getDeploymentDetails
					.then (result) ->
						val =
							count:		processdefList.body.total
							results:	result
						res.ok(val)
			.catch res.serverError

	getDiagram: (req, res) ->
		data = actionUtil.parseValues(req)
		activiti.req 'get', "#{sails.config.activiti.url.deployment data.deploymentId}/resources"
			.then (processdefList) ->
				result = _.findWhere(processdefList.body,{type: 'resource'})
				activiti.getProcDefDiagram "#{sails.config.activiti.url.deployment data.deploymentId}/resourcedata/#{result.id}"
			.then (stream) ->
				res.ok(stream.raw)
			.catch res.serverError						