Promise = require 'promise'
actionUtil = require 'sails/lib/hooks/blueprints/actionUtil'

module.exports =
	find: (req, res) ->
		activiti.getlist(sails.config.activiti.url.runninglist)
			.then (result) ->
				#sails.log.info "res: #{JSON.stringify(result)}"
				val =
					count:		result.total
					results:	result.data
				res.ok(val)
			.catch res.serverError