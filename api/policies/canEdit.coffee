#Task creator can create, delete and edit everything
#Task owner can only edit the 'Actual' fields or delete the task if 'allow task owner to delete' is Yes

actionUtil = require 'sails/lib/hooks/blueprints/actionUtil'
module.exports = (req, res, next) ->
	Model = actionUtil.parseModel(req)
	pk = actionUtil.requirePk(req)
	values = actionUtil.parseValues(req)
	updVal = _.pick(values , "project", "task","notes", "location", "createdBy", "ownedBy", "dateExpect")
	
	if updVal.dateExpect
		updVal.dateExpect = new Date(values.dateExpect)
	_.each ['createdBy', 'ownedBy'], (field) ->
		if updVal[field]
			updVal[field] = updVal[field].username
			
	cond = 
		id:			pk
			
	Model.findOne()
	.where( cond )
	.exec (err, data) ->
		if err
			return res.serverError err
		if data
			isOwnerField = (updVal, data) ->
				_.every _.keys(updVal), (currentKey) ->
					_.has(data, currentKey) and _.isEqual(updVal[currentKey], data[currentKey])
			if req.user.isCreator(data) 
				return next()
			if req.user.isOwner(data) and isOwnerField(updVal, data) 
				return next()		
			res.badRequest "Not authorized to edit with id #{pk}"
		res.notFound()
		