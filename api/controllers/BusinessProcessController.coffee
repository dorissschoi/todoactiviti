Promise = require 'promise'
actionUtil = require 'sails/lib/hooks/blueprints/actionUtil'

getDeploymentUser = (procDef) ->
	sails.models.businessprocess
		.find({deploymentId: procDef.deploymentId})
		.then (rst) ->
			if rst.length > 0
				rst[0].definition = procDef 
			return rst[0]
		.catch (err) ->
			sails.log.error err
			
module.exports =
	find: (req, res) ->
		data = actionUtil.parseValues(req)
		activiti.definition.list data.skip
			.then (processdefList) ->
				Promise.all _.map processdefList.results, getDeploymentUser
			.then (result) ->
				val =
					count:		result.length
					results:	result
				res.ok(val)
			.catch res.serverError			
		
	getDiagram: (req, res) ->
		data = actionUtil.parseValues(req)
		activiti.definition.diagram data.deploymentId
			.then (stream) ->
				res.ok stream
			.catch res.serverError
					