env = require './env.coffee'

require './model.coffee'

angular.module 'starter.controller', [ 'ionic', 'http-auth-interceptor', 'ngCordova',  'starter.model', 'platform']

	.controller 'MenuCtrl', ($scope) ->
		$scope.env = env
		$scope.navigator = navigator

	.controller 'ListBusinessProcessCtrl', ($scope, collection, resources, $location, $ionicModal) ->				
		_.extend $scope,
			
			collection: collection
			
			# save model backend call post
			startProcess: (item) ->
				process = new resources.Processins
					processdefID: item.definition.id
				process.$save()
					.then () ->
						$location.url "/todo/weekList?progress=0&ownedBy=me&sort=createdAt"
									
			opendiagram: (item) ->
				pdModel = new resources.BusinessProcess id: item.deploymentId
				pdModel.$fetch()
					.then (data)->
						src = new Buffer(data).toString('base64')
						src = "data:image/png;base64,#{src}"
						$scope.$emit 'activitiImg', src 
			
			loadMore: ->
				collection.$fetch()
					.then ->
						$scope.$broadcast('scroll.infiniteScrollComplete')
					.catch alert						
					
	.controller 'ListProcessinsCtrl', ($rootScope, $stateParams, $scope, collection, $location, resources) ->
		_.extend $scope,
			
			collection: collection
			
			opendiagram: (item) ->
				piModel = new resources.Processins id: item.processInstanceId
				piModel.$fetch()
					.then (data)->
						src = new Buffer(data).toString('base64')
						src = "data:image/png;base64,#{src}"
						$scope.$emit 'activitiImg', src 
			
			detail: (item) ->
				$location.url "/workflowtask/#{item.processInstanceId}"
							
			loadMore: ->
				collection.$fetch()
					.then ->
						$scope.$broadcast('scroll.infiniteScrollComplete')
					.catch alert			
			
	.controller 'ListCtrl', ($rootScope, $stateParams, $scope, collection, $location, ownedBy, sortBy, progress, $ionicPopup, resources, $ionicModal, $ionicListDelegate, popover) ->
		_.extend popover.scope,
			create: ->
				$location.url "/todo/create"
				popover.hide()
			
			listbyDate: ->
				$location.url "/todo/weekList?progress=0&ownedBy=me&sort=createdAt"
				popover.hide()
			
			listbyProject: ->
				$location.url "/todo/weekList?progress=0&ownedBy=me&sort=project"
				popover.hide()	
				
		_.extend $scope,
			popover: popover
			
			progress: progress
			
			ownedBy: ownedBy
			
			sortBy: sortBy
			
			collection: collection
			
			openurl: (item) ->
				if _.isUndefined(item.type) || item.type =='manual'
					$location.url "/todo/edit/#{item.id}"
				else
					if item.url
						window.open(item.url, '_blank')

			opendiagram: (item) ->
				piModel = new resources.Processins id: item.procInsId
				piModel.$fetch()
					.then (data)->
						src = new Buffer(data).toString('base64')
						src = "data:image/png;base64,#{src}"
						$scope.$emit 'activitiImg', src 
						
			completeTask: (item) ->
				item.progress = 100
				item.dateEnd = new Date
				item.$save()
					.then ->
						$ionicListDelegate.closeOptionButtons()
					.catch (err) ->
						alert err
						collection.$refetch({params: {progress: progress, ownedBy: ownedBy, sort: sortBy }})								
					
			edit: (item) ->
				$location.url "/todo/edit/#{item.id}"		
				
			delete: (item) ->
				collection.remove item
			
			loadMore: ->
				collection.$fetch({params: {progress: progress, ownedBy: ownedBy, sort: sortBy}})
					.then ->
						$scope.$broadcast('scroll.infiniteScrollComplete')
					.catch alert								

	.controller 'TodoCtrl', ($rootScope, $scope, model, $location, userlist, me) ->
		_.extend $scope,
			model: model
			userlist: userlist
			selected: _.findWhere(userlist.models,{username: me.username})
			save: ->
				$scope.model.$save()
					.then ->
						$location.url "/todo/weekList?progress=0&ownedBy=me&sort=createdAt"
					.catch (err) ->
						alert {data:{error: "Not authorized to edit."}}					
		$scope.$on 'selectuser', (event, item) ->
			$scope.model.ownedBy = item

	.controller 'TaskCtrl', ($rootScope, $scope, $location, collection, resources) ->
		_.extend $scope,
			collection: collection
			resources: resources

	.filter 'definitionsFilter', ($ionicScrollDelegate)->
		(collection, search) ->
			if search
				return _.filter collection, (item) ->
					r = new RegExp(search, 'i')
					r.test(item.name)
			else
				return collection

	.filter 'instancesFilter', ($ionicScrollDelegate)->
		(collection, search) ->
			if search
				return _.filter collection, (item) ->
					r = new RegExp(search, 'i')
					r.test(item.name) or r.test(item.nextHandler)
			else
				return collection
				
	.filter 'todosFilter', ($ionicScrollDelegate)->
		(collection, search) ->
			if search
				return _.filter collection, (item) ->
					r = new RegExp(search, 'i')
					r.test(item.project) or r.test(item.task) or r.test(item.createdBy.username) or r.test(item.ownedBy.username)
			else
				return collection
				
	.filter 'UserSearchFilter', ->
		(collection, search) ->
			if search
				return _.filter collection, (item) ->
					r = new RegExp(search, 'i')
					r.test(item.username) 
			else
				return collection