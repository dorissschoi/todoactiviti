Promise = require 'promise'

module.exports =

	req: (method, url, data) ->
		opts = 
			headers:
				Authorization:	"Basic " + new Buffer("#{sails.config.activiti.username}:#{sails.config.activiti.password}").toString("base64")
				'Content-Type': 'application/json'
			json: true

		sails.services.rest[method] {}, url, opts, data
