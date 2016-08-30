env = require './env.coffee'

require './model.coffee'

angular.module 'starter.controller', [ 'ionic', 'http-auth-interceptor', 'ngCordova',  'starter.model', 'platform', 'angular-contextual-date']

	.run (contextualDateService) -> 
		contextualDateService.config.hideFullDate = true

	.controller 'MenuCtrl', ($scope) ->
		$scope.env = env
		$scope.navigator = navigator

	.controller 'ListProcessdefCtrl', ($scope, collection, resources, $location, $ionicModal) ->				
		_.extend $scope,
			
			collection: collection
			
			# save model backend call post
			startProcess: (item) ->
				process = new resources.Processins
					processdefID: item.id
				process.$save()
					.then () ->
						$location.url "/todo/processinsList"
									
			$ionicModal.fromTemplateUrl('templates/modal.html', {
				scope: $scope
			}).then (modal) ->
				$scope.modal = modal;
			
			openModal: (item) ->
				pdModel = new resources.Processdef id: item.deploymentId
				pdModel.$fetch()
					.then (data)->
						$scope.modal.show()	
						src = new Buffer(data).toString('base64')
						src = "data:image/png;base64,#{src}"
						$scope.imgUrl = src
					
	.controller 'ListProcessinsCtrl', ($rootScope, $stateParams, $scope, collection, $location, resources, createdBy) ->
		_.extend $scope,
			
			collection: collection
			
			createdBy: createdBy
			
			loadMore: ->
				collection.state.skip = collection.state.skip + collection.state.limit
				collection.$fetch()
					.then ->
						$scope.$broadcast('scroll.infiniteScrollComplete')
					.catch alert			
			
	.controller 'ListCtrl', ($rootScope, $stateParams, $scope, collection, $location, ownedBy, sortBy, sortOrder, progress, $ionicPopup, resources, $ionicModal, $ionicListDelegate) ->
		_.extend $scope,
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

			$ionicModal.fromTemplateUrl('templates/modal.html', {
				scope: $scope
			}).then (modal) ->
				$scope.modal = modal;
						
			opendiagram: (item) ->
				piModel = new resources.Processins id: item.procInsId
				piModel.$fetch()
					.then (data)->
						$scope.modal.show()	
						src = new Buffer(data).toString('base64')
						src = "data:image/png;base64,#{src}"
						$scope.imgUrl = src
						
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
			
			order: (field) ->
				$rootScope.sort = field 
			
			neworder: (field) ->
				if !sortOrder.localeCompare("asc")
						sortOrder = "desc"
					else 
						sortOrder = "asc"
		
				sortBy = "#{field} #{sortOrder}"	
				collection.$refetch({params: {progress: progress, ownedBy: ownedBy, sort: sortBy }}) 
				
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
						$location.url "/todo/weekList?progress=0&ownedBy=me&sort=project desc"
					.catch (err) ->
						alert {data:{error: "Not authorized to edit."}}					
		$scope.$on 'selectuser', (event, item) ->
			$scope.model.ownedBy = item

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
					r.test(item.username()) 
			else
				return collection