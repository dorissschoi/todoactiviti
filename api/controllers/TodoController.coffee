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
		pk = actionUtil.requirePk req
		values = actionUtil.parseValues req
		
		if parseInt(req.body.progress) == 100
			values.progress = parseInt(req.body.progress) 
		if values.progress == 100 && req.body.type != 'manual'
			activiti.completeTask req.body.taskId, req.user
		
		Model.update(pk, values)
			.then (updatedRecord) ->
				res.ok()
			.catch res.serverError

	completeActiviti: (req, res) ->
		pk = actionUtil.requirePk req
		values = actionUtil.parseValues req
		
		sails.log.info "completeActiviti: #{JSON.stringify values}"
		
		sails.models.todo
			.findOne()
			.where(id: pk)
			.populateAll()
			.then (todo) ->
				activiti.completeTask values.taskId, req.user
					.then (rst) ->
						sails.models.todo.update(pk, {progress: 100})
							.then (updatedRecord) ->
								res.ok()
			.catch res.serverError		

		
				