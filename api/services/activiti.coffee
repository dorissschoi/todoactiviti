Promise = require 'promise'
querystring = require 'querystring'

module.exports =
	#promise to get activiti process definition
	#curl -X GET  --basic --user <>:<> http://localhost:8080/activiti-rest/service/repository/process-definitions
	processdeflist: () ->
			url = sails.config.activiti.url.processdef
			username = sails.config.activiti.username
			password = sails.config.activiti.password
			param =
				categoryLike: 'processdef'
				
			new Promise (resolve, reject) ->
				#sails.services.rest.basicget "#{url}?#{querystring.stringify(param)}", "#{username}", "#{password}"
				sails.services.rest.basicget "#{url}", "#{username}", "#{password}"
					.then (res) ->
						#sails.log.info "res: #{JSON.stringify(res.body)}"
						if !_.isUndefined res.body.data
							resolve res.body
						else
							reject new Error "Get Activiti data failed"
					.catch reject	