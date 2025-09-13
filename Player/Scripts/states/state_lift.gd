class_name State_Lift extends State

@export var lift_audio : AudioStream

@onready var carry : State = $"../Carry"

var start_anim_late : bool = false



func enter() -> void:
	player.update_animation( "lift" )
	if start_anim_late == true:
		player.animation_player.seek( 0.25 )
	player.animation_player.animation_finished.connect( _state_complete )
	player.audio.stream = lift_audio
	player.audio.play()
	pass
	

func exit() -> void:
	start_anim_late = false
	pass
	
	
func process( _delta : float ) -> State:
	player.velocity = Vector2.ZERO
	return null



func _state_complete( _a : String ) -> void:
	player.animation_player.animation_finished.disconnect( _state_complete )
	state_machine.change_state( carry )
	pass








	
