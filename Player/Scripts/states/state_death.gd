class_name State_Death extends State

@export var exhaust_audio : AudioStream


func enter() -> void:
	player.animation_player.play( "death" )
	AudioManager.play_ui( exhaust_audio )
	PlayerHud.show_game_over_screen()
	AudioManager.play_music( null ) # Cuts BG music
	
	
func process( _delta : float ) -> State:
	player.velocity = Vector2.ZERO
	return null
