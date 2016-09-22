module.exports = 
	routes:
		'GET /api/processins/:procInsId':
			controller:		'ProcessinsController'
			action:			'getDiagram'

		'GET /api/processdef/:deploymentId':
			controller:		'ProcessdefController'
			action:			'getDiagram'
		
		'PUT /api/todo/:id/complete':
			controller:		'TodoController'
			action:			'completeActiviti'			