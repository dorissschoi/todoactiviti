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
			data =
				action: 'complete'
				variables: [{name: 'completedBy', value: req.user}]
			activiti.task.update req.body.taskId, data
		
		Model.update(pk, values)
			.then (updatedRecord) ->
				res.ok()
			.catch res.serverError
			
	#webhook
	completeActiviti: (req, res) ->
		pk = actionUtil.requirePk req
		values = actionUtil.parseValues req
		
		sails.log.info "completeActiviti: #{JSON.stringify values}"
		
		sails.models.todo
			.findOne(pk)
			.populateAll()
			.then (todo) ->
				data =
					action: 'complete'
					variables: [{name: 'completedBy', value: req.user}]
				_.each values, (value, key) ->
					data.variables.push {name:key, value:value}	
				activiti.task.update todo.taskId, data
			.then (rst) ->
				sails.models.todo.update(pk, {progress: 100})
			.then (updatedRecord) ->
				res.ok()
			.catch res.serverError		

		
	destroy: (req, res) ->
		pk = actionUtil.requirePk req
		Model = actionUtil.parseModel req
		
		Model.findOne(pk)
			.populateAll()
			.then (result) ->
				if result.type == 'activiti'
					activiti.instance.delete result.procInsId
					Model.destroy({procInsId: result.procInsId})
				else	
					Model.destroy(pk)
			.then (result) ->
				res.ok()	
			.catch res.serverError	
		
