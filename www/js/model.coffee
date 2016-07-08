require 'PageableAR'

angular.module 'starter.model', ['PageableAR']

	.factory 'resources', (pageableAR) ->

		class Todo extends pageableAR.Model
			$idAttribute: 'id'
			
			$urlRoot: "api/todo/"
			
			$parse: (res, opts) ->
				if !_.isUndefined(res.dateStart)
					if !_.isNull(res.dateStart)
						res.dateStart = new Date(res.dateStart)
				if !_.isUndefined(res.dateEnd)
					if !_.isNull(res.dateEnd)
						res.dateEnd = new Date(res.dateEnd)
				if !_.isUndefined(res.dateExpect)
					if !_.isNull(res.dateExpect)
						res.dateExpect = new Date(res.dateExpect)						
				return res

		# TodoList
		class TodoList extends pageableAR.PageableCollection

			model: Todo
			
			$urlRoot: "api/todo/"

		class User extends pageableAR.Model
			$idAttribute: 'username'
			
			$urlRoot: "api/user/"
			
			_me = null
			
			@me: ->
				_me ?= new User username: 'me'
		
		# UserList
		class UserList extends pageableAR.PageableCollection

			model: User
			
			$urlRoot: "api/user/"
			
						
		class Processdef extends pageableAR.Model
			$idAttribute: 'id'
			
			$urlRoot: "api/processdef/"
				
		# ProcessdefList
		class ProcessdefList extends pageableAR.PageableCollection
			model: Processdef
		
			$urlRoot: "api/processdef/"
								
		Todo:		Todo
		TodoList:	TodoList
		User:		User
		UserList:	UserList
		Processdef:	Processdef
		ProcessdefList: ProcessdefList
