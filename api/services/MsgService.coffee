http = require 'needle'
Promise = require 'bluebird'

options = 
	timeout:	sails.config.promise.timeout

module.exports = 
	sendMsg: (values) ->
		if sails.config.im.sendmsg
			sails.services.rest.token sails.config.oauth2.tokenURL, sails.config.im.client, sails.config.im.user, sails.config.im.scope
				.then (result) ->
					opts = _.extend options, 
						headers:
							Authorization:	"Bearer #{result.body.access_token}"
					data = 
						from: 	sails.config.im.adminjid
						to:		"#{values.ownedBy}@#{sails.config.im.xmpp.domain}"
						body: 	sails.config.im.txt	+ " : "+ values.task	
					
					sails.services.rest.post user.token, sails.config.im.url, opts, data
				.then (res) ->
					sails.log.info "Notification is sent to " + res.body.to					
				.catch (err) ->
					sails.log.error err	
		else
			sails.log.warn "Send notification is disabled. Please check system configuration."
