env = require './env.coffee'

require './model.coffee'

angular.module 'starter.controller', [ 'ionic', 'http-auth-interceptor', 'ngCordova',  'starter.model', 'platform']

	.controller 'MenuCtrl', ($scope) ->
		$scope.env = env
		$scope.navigator = navigator

	.controller 'ListProcessdefCtrl', ($rootScope, $stateParams, $scope, collection, $location) ->
		_.extend $scope,
			
			collection: collection
			
			loadMore: ->
				collection.$fetch()
					.then ->
						$scope.$broadcast('scroll.infiniteScrollComplete')
					.catch alert

	.controller 'ListCtrl', ($rootScope, $stateParams, $scope, collection, $location, ownedBy, sortBy, sortOrder) ->
		_.extend $scope,
			ownedBy: ownedBy
			
			sortBy: sortBy
			
			collection: collection
			
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
				collection.$refetch({params: {ownedBy: ownedBy, sort: sortBy }}) 
				
			loadMore: ->
				collection.$fetch({params: {ownedBy: ownedBy, sort: sortBy}})
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
						$location.url "/todo/weekList?ownedBy=me&sort=project desc"
					.catch (err) ->
						alert {data:{error: "Not authorized to edit."}}					
		$scope.$on 'selectuser', (event, item) ->
			$scope.model.ownedBy = item

	.filter 'todosFilter', ($ionicScrollDelegate)->
		(collection, search, skip, count, limit) ->
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