Promise = require 'bluebird'
activiticlient = require 'activiti-client'
		
module.exports =
	definition:
		list: (page) ->
			activiticlient.definition.list page
			
		getDiagram: (depId) ->	
			activiticlient.definition.diagram depId
	
	instance:
		findbyUser: (page, user) ->
			activiticlient.instance.list page, user	
			
		create: (procdefId, user) ->
			activiticlient.instance.create procdefId, user	
		
		getDiagram: (procInsId) ->	
			activiticlient.instance.diagram procInsId

		getHistory: (page, procInsId) -> 
			activiticlient.instance.historyTasklist page, procInsId
		
		#complete task
		update: (taskId, user) ->	
			activiticlient.instance.update taskId, user
		
		delete: (procInsId) ->	
			activiticlient.instance.delete procInsId