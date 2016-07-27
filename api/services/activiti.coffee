Promise = require 'promise'

module.exports =

	req: (method, url, data) ->
		auth = "Basic " + new Buffer("#{sails.config.activiti.username}:#{sails.config.activiti.password}").toString("base64")
		opts = 
			headers:
				Authorization:	auth
				'Content-Type': 'application/json'
			json: true
		
		new Promise (resolve, reject) ->
			sails.services.rest[method] {}, url, opts, data
				.then (res) ->
					resolve res
				.catch reject
				
	getlist: (url) ->
		@req "get", url
			.then (res) ->
				if !_.isUndefined res.body.data
					return res.body
				else
					return new Error "get activiti data failed"
			
	startprocessins: (processdefID) ->
		data = 
			processDefinitionId: processdefID
		@req "post", sails.config.activiti.url.startprocessins, data
			.then (res) ->
				if res.statusCode == 201
					return res.body
				else
					return new Error "Start activiti process instance failed"
								