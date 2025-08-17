extends Node


signal quest_updated( q )

#const QUEST_DATA_LOCATION : String = "res://Quests_old/"

#var quests : Array[ Quest2 ] ## keeps track of ALL of the game quests (.tres)
var current_quests : Array = []


func _ready() -> void:
	#gather_quest_data()
	pass



# Give XP and item rewards to player
func disperse_quest_rewards( _q : Quest2 ) -> void:
	var _message : String = str( _q.reward_xp ) + " XP"
	PlayerManager.reward_xp( _q.reward_xp )
	
	for i in _q.reward_items:
		PlayerManager.INVETORY_DATA.add_item( i.item, i.quantity )
		_message += ", " + i.item.name + " x" + str( i.quantity )
	PlayerHud.queue_notification( "You get ", _message  )
	pass

#func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_pressed("test"):
		#print( find_quest( load("res://Quests/recover_lost_flute.tres") as Quest2 ) )
		#print( find_quest_by_title( "Short Quest") )
		#print( get_quest_index_by_title( "Find lost thing" ) )
		#print( get_quest_index_by_title( "Short Quest" ) )
		
		#print( "before: ", current_quests )
		#update_quest( "Find lost thing" )
		#update_quest( "Find lost thing", "", true )
		#update_quest( "short quest", "", true )
		#update_quest( "long quest", "step 1" )
		#update_quest( "long quest", "step 2" )

		#print( "after: ", current_quests )
		#print("==================================================")


#func gather_quest_data() -> void:
	#var quest_files : PackedStringArray = DirAccess.get_files_at( QUEST_DATA_LOCATION )
	#quests.clear()
	#for q in quest_files: 
		#quests.append( load( QUEST_DATA_LOCATION + "/" + q ) as Quest2 )
		#pass
	#print( "Quest2 Count: ", quests.size())
	#pass
	
	
	
#func update_quest( _title : String, _completed_step : String = "", _is_complete : bool = false ) -> void:
	#var quest_index : int = get_quest_index_by_title( _title )
	##Quest2 not found, add it to the array
	#if quest_index == -1:
		#var new_quest : Dictionary = { 
				#title = _title,
				#is_complete = _is_complete,
				#completed_steps = [] 
		#}
		#if _completed_step != "":
			#new_quest.completed_steps.append( _completed_step.to_lower() )
			#
		#current_quests.append( new_quest )
		#quest_updated.emit( new_quest )
		#
		## Display a notification that quest was added
		#PlayerHud.queue_notification( "Quest2 Started", _title )
		#pass
	#else:
		## Quest2 was found, update it
		#var q = current_quests[ quest_index ]
		#if _completed_step != "" and q.completed_steps.has( _completed_step ) == false:
			#q.completed_steps.append( _completed_step.to_lower() )
			#pass
		#q.is_complete = _is_complete
		#
		#quest_updated.emit( q )
		#
		## Display a notification that quests was updated OR completed
		#if q.is_complete == true:
			#PlayerHud.queue_notification( "Quest2 Complete! ", _title + " !" )
			#disperse_quest_rewards( find_quest_by_title( _title ) )
		#else:
			#PlayerHud.queue_notification( "Quest2 Updated", _title + ": " + _completed_step )
		#pass
	#pass


## Provide a quest and return the current quest associated with it
#func find_quest( _quest : Quest2 ) -> Dictionary:
	#for q in current_quests:
		#if q.title.to_lower() == _quest.title.to_lower():
			#return q
	#return { title = "not found", is_complete = false, completed_steps = [''] }



## Take title and find associated Quest2 resource
#func find_quest_by_title( _title : String ) -> Quest2:
	#for q in quests:
		#if q.title.to_lower() == _title.to_lower():
			#return q
	#return null


## Find quest by title name, and return index in Current Quests array
#func get_quest_index_by_title( _title : String ) -> int:
	#for i in current_quests.size():
		#if current_quests[ i ].title.to_lower() == _title.to_lower():
			#return i
	## Return a -1 if we didn't find a quest with
	## a matching title in our arry
	#return -1



#func sort_quests() -> void:
	#var active_quests : Array = []
	#var completed_quests : Array = []
	#for q in current_quests:
		#if q.is_complete:
			#completed_quests.append( q )
		#else:
			#active_quests.append( q )
	#
	#active_quests.sort_custom( sort_quests_ascending )
	#completed_quests.sort_custom( sort_quests_ascending )
	#
	#current_quests = active_quests
	#current_quests.append_array( completed_quests )
	#
	#pass


#func sort_quests_ascending( a, b ):
	#if a.title < b.title:
		#return true
	#return false
