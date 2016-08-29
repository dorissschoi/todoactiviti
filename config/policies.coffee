
module.exports = 
	policies:
		TodoController:
			'*':		false
			find:		['isAuth', 'todo/resolveMe']	
			findOne:	['isAuth']			
			create: 	['isAuth', 'setCreatedBy' , 'setOwner']
			update: 	['isAuth', 'canEdit']
			destroy: 	['isAuth', 'canDestroy']
		UserController:
			'*':		false
			find:		true
			findOne:	['isAuth', 'user/me']
		ProcessinsController:
			'*':		false
			find:		['isAuth']
			findOne:	['isAuth']		
			create: 	['isAuth', 'setCreatedBy']
			getDiagram:	true
		ProcessdefController:
			'*':		false
			find:		['isAuth']
			findOne:	['isAuth']		
				