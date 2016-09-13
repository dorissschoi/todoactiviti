 # TodoController
 #
 # @description :: Server-side logic for managing todoes
 # @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
actionUtil = require 'sails/lib/hooks/blueprints/actionUtil'

module.exports =
	
	find: (req, res) ->
		sails.services.crud.find(req).then res.ok, res.serverError
		
	update: (req, res) ->
		Model = actionUtil.parseModel req
		data = actionUtil.parseValues(req)
		
		if ( req.body.progress == 100 || parseInt(req.body.progress) == 100 ) && req.body.type != 'manual'
			activiti.completeTask req.body.taskId, req.user
		
		Model.update({ id: req.body.id },data)
			.then (values) ->
				res.ok()
			.catch res.serverError	