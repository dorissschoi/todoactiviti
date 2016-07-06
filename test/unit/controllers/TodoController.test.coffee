request = require('supertest')
assert = require('assert')

describe 'TodoController', ->
	id = null
	describe ' POST /api/todo', ->
		it 'responds with create success', (done) ->
			request(sails.hooks.http.app).post('/api/todo').set('Authorization',"Bearer #{sails.token}").send(task: 'apps1').end (err, res) ->
				assert.equal err, null
				assert.equal res.status, '201'
				
				body = JSON.parse(res.text)
				id = body.id
				
				done()
				return
			return
		return 

	describe ' GET /api/todo', ->
		it 'responds with list data', (done) ->
			request(sails.hooks.http.app).get('/api/todo').set('Authorization',"Bearer #{sails.token}").end (err, res) ->
				assert.equal err, null
				assert.equal res.status, '200'
				done()
				return
			return
		return

	describe ' PUT /api/todo', ->
		it 'responds with update data', (done) ->
			request(sails.hooks.http.app).put('/api/todo/' + id).set('Authorization',"Bearer #{sails.token}").send(task: 'apps2').end (err, res) ->
				assert.equal err, null
				assert.equal res.status, '200'
				done()
				return
			return
		return		
				
	describe ' DELETE /api/todo', ->
		it 'responds with delete success', (done) ->
			request(sails.hooks.http.app).delete('/api/todo/' + id).set('Authorization',"Bearer #{sails.token}").end (err, res) ->
				assert.equal err, null
				assert.equal res.status, '200'
				done()
				return
			return
		return 				 			