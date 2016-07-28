Promise = require 'promise'
actionUtil = require 'sails/lib/hooks/blueprints/actionUtil'

module.exports =
	find: (req, res) ->
		activiti.req 'get', sails.config.activiti.url.processdeflist
			.then (result) ->
				val =
					count:		result.body.total
					results:	result.body.data
				res.ok(val)
			.catch res.serverError