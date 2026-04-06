extends Node

var music_audio_player_count : int = 2
var current_music_player : int = 0
var music_players : Array[ AudioStreamPlayer ]
var music_bus : String = "Music"
var effect_bus : String = "Effects"
var effect_player_count : int = 8
var effect_players : Array[ AudioStreamPlayer ]
var ui_bus : String = "UI"
var ui_player_count : int = 8
var ui_players : Array[ AudioStreamPlayer ]
var music_fade_duration : float = 0.666


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS ## Don't pause the music when we pause the game to change levels
	for i in music_audio_player_count:
		var audio_player = AudioStreamPlayer.new()
		add_child( audio_player )
		audio_player.bus = music_bus
		music_players.append( audio_player )
	
	for i in effect_player_count:
		var effect_player = AudioStreamPlayer.new()
		add_child( effect_player )
		effect_player.bus = effect_bus
		effect_players.append( effect_player )

	for i in ui_player_count:
		var ui_player = AudioStreamPlayer.new()
		add_child( ui_player )
		ui_player.bus = ui_bus
		ui_players.append( ui_player )



func play_effect( _audio : AudioStream ) -> void:
	for player in effect_players:
		if not player.playing:
			player.stream = _audio
			player.play()
			return
	effect_players[0].stream = _audio
	effect_players[0].play()
	

func play_ui( _audio : AudioStream ) -> void:
	for player in ui_players:
		if not player.playing:
			player.stream = _audio
			player.play()
			return
	ui_players[0].stream = _audio
	ui_players[0].play()

	
func play_music( _audio : AudioStream ) -> void:
	if _audio == music_players[ current_music_player ].stream:
		return ## don't change the music if it's the same
	current_music_player += 1
	if current_music_player > 1:
		current_music_player = 0
	var current_player : AudioStreamPlayer = music_players[ current_music_player ]
	current_player.stream = _audio
	fade_in( current_player )
	
	var old_player = music_players[ 1 ]
	if current_music_player == 1:
		old_player = music_players[ 0 ]
	fade_out( old_player )


func fade_in( audio_player : AudioStreamPlayer) -> void:
	audio_player.play( 0 )
	var tween : Tween = create_tween()
	tween.tween_property( audio_player, "volume_db", 0, music_fade_duration )


func fade_out( audio_player : AudioStreamPlayer) -> void:
	var tween : Tween = create_tween()
	tween.tween_property( audio_player, "volume_db", -40, music_fade_duration )
	await  tween.finished
	audio_player.stop()


#func pitch( _p ) -> void:
	#var current_player : AudioStreamPlayer = music_players[ current_music_player ]
	#var tween : Tween = create_tween()
	#tween.tween_property( current_player, "pitch_scale", _p, 0.666 )
	#prints( current_player, _p )
