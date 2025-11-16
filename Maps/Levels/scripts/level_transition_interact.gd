@tool
class_name LevelTransitionInteract extends LevelTransition

func _ready() -> void:
	super() # runs the ready function of parent class, LevelTransition
	area_entered.connect( _on_area_entered )
	area_exited.connect( _on_area_exited ) # Only player interact collision can touch Mask 3
	

func player_interact() -> void:
	_player_entered( PlayerManager.player )
	pass

	
func _on_area_entered( _a : Area2D ) -> void:
	PlayerManager.interact_pressed.connect( player_interact )
	pass


func _on_area_exited( _a : Area2D ) -> void:
	pass
