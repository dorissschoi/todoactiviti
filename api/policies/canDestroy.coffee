#Task creator can create, delete and edit everything
#Task owner can only edit the 'Actual' fields or delete the task if 'allow task owner to delete' is Yes

actionUtil = require 'sails/lib/hooks/blueprints/actionUtil'
 
module.exports = (req, res, next) ->
	
	model = req.options.model || req.options.controller
	Model = actionUtil.parseModel(req)
	pk = actionUtil.requirePk(req)
		
	cond = 
			id:			pk
			
	Model.findOne()
		.where( cond )
		.exec (err, data) ->
			if err
				return res.serverError err
			if data
				if req.user.isCreator(data) 
					return next()
				if req.user.isOwner(data) and data.ownerDel == true 
					return next()		
				res.badRequest "Not authorized to delete with id #{pk}"
			res.notFound()