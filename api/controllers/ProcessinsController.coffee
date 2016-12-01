Promise = require 'bluebird'
actionUtil = require 'sails/lib/hooks/blueprints/actionUtil'


module.exports =
	find: (req, res) ->
		data = actionUtil.parseValues(req)
		activiti.instance.findbyUser data.skip, req.user 
			.then (result) ->
				res.ok(result)
			.catch res.serverError
			
	create: (req, res) ->
		data = actionUtil.parseValues(req)
		activiti.instance.create data.processdefID, req.user
			.then (rst) ->
				if rst.statusCode == 201
					res.ok(rst.body) 
				else 
					res.notFound(rst.body)				
			.catch res.serverError

	getDiagram: (req, res) ->
		data = actionUtil.parseValues(req)
		activiti.instance.getDiagram data.procInsId
			.then (stream) ->
				res.ok stream
			.catch res.serverError