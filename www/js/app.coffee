env = require './env.coffee'

angular.module 'starter', ['ngFancySelect', 'ionic', 'util.auth', 'starter.controller', 'starter.model', 'http-auth-interceptor', 'ngTagEditor', 'ActiveRecord', 'ngTouch', 'ngAnimate', 'pascalprecht.translate', 'locale']
	
	.run (authService) ->
		authService.login env.oauth2.opts
	        
	.run ($rootScope, platform, $ionicPlatform, $location, $http) ->
		$ionicPlatform.ready ->
			if (window.cordova && window.cordova.plugins.Keyboard)
				cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true)
			if (window.StatusBar)
				StatusBar.styleDefault()

	.run ($rootScope, $ionicModal) ->
		$rootScope.$on 'activitiImg', (event, inImg) ->
			_.extend $rootScope,
				imgUrl: inImg
			
			$ionicModal.fromTemplateUrl 'templates/modal.html', scope: $rootScope
				.then (modal) ->
					modal.show()
					$rootScope.modal = modal
											
	.config ($stateProvider, $urlRouterProvider, $translateProvider) ->
	
		$stateProvider.state 'app',
			url: ""
			abstract: true
			templateUrl: "templates/menu.html"
	
		$stateProvider.state 'app.createTodo',
			url: "/todo/create"
			cache: false
			views:
				'menuContent':
					templateUrl: "templates/todo/create.html"
					controller: 'TodoCtrl'
			resolve:
				resources: 'resources'
				userlist: (resources) ->
					ret = new resources.UserList()
					ret.$fetch()
				me: (resources) ->
					resources.User.me().$fetch()							
				model: (resources) ->
					ret = new resources.Todo()				
	
		$stateProvider.state 'app.editTodo',
			url: "/todo/edit/:id"
			cache: false
			views:
				'menuContent':
					templateUrl: "templates/todo/edit.html"
					controller: 'TodoCtrl'
			resolve:
				id: ($stateParams) ->
					$stateParams.id
				resources: 'resources'
				userlist: (resources) ->
					ret = new resources.UserList()
					ret.$fetch()
				me: (resources) ->
					resources.User.me().$fetch()
				model: (resources, id) ->
					ret = new resources.Todo({id: id})
					ret.$fetch()			
		
		$stateProvider.state 'app.list',
			url: "/todo/weekList?progress&ownedBy&sort&sortOrder"
			cache: false
			views:
				'menuContent':
					templateUrl: "templates/todo/list.html"
					controller: 'ListCtrl'
			resolve:
				progress: ($stateParams) ->
					return $stateParams.progress
				ownedBy: ($stateParams) ->
					return $stateParams.ownedBy
				sortBy: ($stateParams) ->
					return $stateParams.sort
				sortOrder: ($stateParams) ->
					if _.isUndefined($stateParams.sortOrder)
						return 'asc'
					else 
						return $stateParams.sortOrder	
					
				resources: 'resources'	
				collection: (resources, ownedBy, sortBy, progress) ->
					ret = new resources.TodoList()
					ret.$fetch({params: {progress: progress, ownedBy: ownedBy, sort: sortBy}})
		
		$stateProvider.state 'app.listProcessdef',
			url: "/todo/processdefList"
			cache: false
			views:
				'menuContent':
					templateUrl: "templates/processdef/list.html"
					controller: 'ListProcessdefCtrl'
			resolve:
				resources: 'resources'
				collection: (resources) ->
					ret = new resources.ProcessdefList()
					ret.$fetch()

		$stateProvider.state 'app.listProcessins',
			url: "/todo/processinsList?createdBy"
			cache: false
			views:
				'menuContent':
					templateUrl: "templates/processins/list.html"
					controller: 'ListProcessinsCtrl'
			resolve:
				createdBy: ($stateParams) ->
					return $stateParams.createdBy
				resources: 'resources'
				collection: (resources, createdBy) ->
					ret = new resources.ProcessinsList()
					ret.$fetch()		
		
					
		$urlRouterProvider.otherwise('/todo/weekList?progress=0&ownedBy=me&sort=project desc')				
		#$urlRouterProvider.otherwise('/todo/processdefList')
		
		
		