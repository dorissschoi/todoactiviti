module.exports = 
	routes:
		'GET /api/processins/:procInsId':
			controller:		'ProcessinsController'
			action:			'getDiagram'

		'GET /api/processdef/:deploymentId':
			controller:		'ProcessdefController'
			action:			'getDiagram'