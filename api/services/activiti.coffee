Promise = require 'promise'

module.exports =

	req: (method, url, data) ->
		opts = 
			headers:
				Authorization:	"Basic " + new Buffer("#{sails.config.activiti.username}:#{sails.config.activiti.password}").toString("base64")
				'Content-Type': 'application/json'
			json: true

		sails.services.rest[method] {}, url, opts, data
				
	getlist: (url) ->
		@req "get", url
			.then (res) ->
				if !_.isUndefined res.body.data
					return res.body
				else
					return new Error "get activiti data failed"
			
	startprocessins: (processdefID, createdBy) ->
		data = 
			processDefinitionId: processdefID
			variables: [{name: 'createdBy', value: createdBy}]
		@req "post", sails.config.activiti.url.startprocessins, data
			.then (res) ->
				if res.statusCode == 201
					return res.body
				else
					return new Error "Start activiti process instance failed"
								
