module.exports = 
	routes:
		'GET /api/todo':
			controller:		'TodoController'
			action:			'find'

		'GET /api/processdef':
			controller:		'ProcessdefController'
			action:			'find'

		'GET /api/processins':
			controller:		'ProcessinsController'
			action:			'find'
												