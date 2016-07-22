
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
		