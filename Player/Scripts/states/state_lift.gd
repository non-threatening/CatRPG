class_name State_Lift extends State

@export var lift_audio : AudioStream

@onready var carry : State = $"../Carry"


func enter() -> void:
	player.update_animation( "lift" )
	player.animation_player.animation_finished.connect( _state_complete )
	player.audio.stream = lift_audio
	player.audio.play()
	pass
	
	
	
func process( _delta : float ) -> State:
	player.velocity = Vector2.ZERO
	return null



func _state_complete( _a : String ) -> void:
	player.animation_player.animation_finished.disconnect( _state_complete )
	print("enter carry state")
	state_machine.change_state( carry )
	pass








	
