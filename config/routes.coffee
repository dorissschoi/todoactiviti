module.exports = 
	routes:
		'GET /api/processins/:procInsId':
			controller:		'ProcessinsController'
			action:			'getDiagram'

		'GET /api/businessProcess/:deploymentId':
			controller:		'BusinessProcessController'
			action:			'getDiagram'
		
		'PUT /api/todo/:id/complete':
			controller:		'TodoController'
			action:			'completeActiviti'			