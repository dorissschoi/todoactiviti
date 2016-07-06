actionUtil = require 'sails/lib/hooks/blueprints/actionUtil'

module.exports = (req, res, next) ->
	if _.isUndefined req.query.ownedBy
		return next()
		
	if req.query.ownedBy == 'me'
		req.query.ownedBy = req.user.username
		next()
	else
		sails.models.user.findOne()
			.where( {username: req.query.ownedBy} )
			.then (user) ->
				if user
					req.query.ownedBy = user.username
					next()
				else
					res.notFound("username: #{req.query.ownedBy}")	
			.catch res.serverError
				