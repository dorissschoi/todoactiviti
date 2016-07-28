request = require('supertest')
assert = require('assert')
env = require '../../activiti.coffee'

describe 'activiti services', ->

	describe ' GET /activiti-rest/service/repository/process-definitions', ->
		it 'responds with list data', (done) ->
			sails.services.activiti.req "get", env.activiti.url.processdeflist
				.then (res) ->
					console.log "url: " + env.activiti.url.processdeflist
					assert.equal res.statusCode, '200'
					done()
				.catch done
			