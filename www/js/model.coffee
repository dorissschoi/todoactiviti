require 'PageableAR'

angular.module 'starter.model', ['PageableAR']

	.factory 'resources', (pageableAR) ->

		class Todo extends pageableAR.Model
			$idAttribute: 'id'
			
			$urlRoot: "api/todo"
			
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
				if !_.isUndefined(res.procCreateDate)
					if !_.isNull(res.procCreateDate)
						res.procCreateDate = new Date(res.procCreateDate)									
				return res

		# TodoList
		class TodoList extends pageableAR.PageableCollection

			model: Todo
			
			$urlRoot: "api/todo"

		class User extends pageableAR.Model
			$idAttribute: 'username'
			
			$urlRoot: "api/user"
			
			_me = null
			
			@me: ->
				_me ?= new User username: 'me'
		
		# UserList
		class UserList extends pageableAR.PageableCollection

			model: User
			
			$urlRoot: "api/user"
			
						
		class BusinessProcess  extends pageableAR.Model
			$idAttribute: 'id'
			
			$urlRoot: "api/businessProcess"
				
		# BusinessProcessList 
		class BusinessProcessList  extends pageableAR.PageableCollection
			model: BusinessProcess
		
			$urlRoot: "api/businessProcess"

		class Processins extends pageableAR.Model
			$idAttribute: 'id'
			
			$urlRoot: "api/processins"
		
		# ProcessinsList
		class ProcessinsList extends pageableAR.PageableCollection
			model: Processins
		
			$urlRoot: "api/processins"	
			
		class WorkflowTask extends pageableAR.Model
			$idAttribute: 'id'
			
			$urlRoot: "api/workflowtask"
		
		# WorkflowTaskList
		class WorkflowTaskList extends pageableAR.PageableCollection
			model: WorkflowTask
		
			$urlRoot: "api/workflowtask"				
											
		Todo:		Todo
		TodoList:	TodoList
		User:		User
		UserList:	UserList
		BusinessProcess:	BusinessProcess
		BusinessProcessList: BusinessProcessList
		Processins: Processins
		ProcessinsList: ProcessinsList
		WorkflowTask: WorkflowTask
		WorkflowTaskList: WorkflowTaskList
		
