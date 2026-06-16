extends Node

var ambient_audio_player_count : int = 8
var ambient_players : Array[ AudioStreamPlayer ]
var current_ambient_player : int = 0
var ambient_fade_duration : float = 0.666

var music_audio_player_count : int = 2
var music_players : Array[ AudioStreamPlayer ]
var current_music_player : int = 0
var music_fade_duration : float = 1.8

var effect_player_count : int = 8
var effect_players : Array[ AudioStreamPlayer ]

var ui_player_count : int = 8
var ui_players : Array[ AudioStreamPlayer ]


func _ready() -> void:
	## Don't pause the music when we pause the game to change levels
	process_mode = Node.PROCESS_MODE_ALWAYS 
	# Initialize ambient players container
	ambient_players = []
	for i in music_audio_player_count:
		var audio_player = AudioStreamPlayer.new()
		add_child( audio_player )
		audio_player.bus = &"Music"
		music_players.append( audio_player )
	
	for i in effect_player_count:
		var effect_player = AudioStreamPlayer.new()
		add_child( effect_player )
		effect_player.bus = &"Effects"
		effect_players.append( effect_player )

	for i in ui_player_count:
		var ui_player = AudioStreamPlayer.new()
		add_child( ui_player )
		ui_player.bus = &"UI"
		ui_players.append( ui_player )


## Ambient track management
func add_ambient( _audio : AudioStream, _volume_db : float = 0.0 ) -> AudioStreamPlayer:
	if _audio == null:
		return null
	if _is_ambient_playing( _audio ):
		return null
	if ambient_players.size() >= ambient_audio_player_count:
		return null
	var player = AudioStreamPlayer.new()
	add_child( player )
	player.bus = &"Ambient"
	player.stream = _audio
	player.volume_db = -40
	player.play()
	ambient_players.append( player )
	var tween : Tween = create_tween()
	tween.tween_property( player, "volume_db", _volume_db, ambient_fade_duration )
	return player

func _is_ambient_playing( _audio : AudioStream ) -> bool:
	for player in ambient_players:
		if player.playing and player.stream == _audio:
			return true
	return false

func remove_ambient( track ) -> void:
	var player : AudioStreamPlayer = null
	if typeof( track ) == TYPE_INT:
		if track < 0 or track >= ambient_players.size():
			return
		player = ambient_players[ track ]
	elif typeof(track) == TYPE_OBJECT and is_instance_valid(track) and track is AudioStreamPlayer:
		if ambient_players.has( track ):
			player = track
		#else:
			#return
	#else:
		#return

	var tween : Tween = create_tween()
	tween.tween_property( player, "volume_db", -40, ambient_fade_duration )
	await tween.finished
	if player.playing:
		player.stop()
	player.queue_free()
	var idx = ambient_players.find( player )
	if idx != -1:
		ambient_players.remove_at( idx )

func remove_all_ambients() -> void:
	for player in ambient_players:
		if player.playing:
			var tween : Tween = create_tween()
			tween.tween_property( player, "volume_db", -40, ambient_fade_duration )
			await tween.finished
			player.stop()
		player.queue_free()
	ambient_players.clear()


## Play with AudioStream. Second var is pitch_scale; default = 1
func play_effect( _audio : AudioStream, _pitch_scale : float = 1 ) -> void:
	for player in effect_players:
		if not player.playing:
			player.stream = _audio
			player.pitch_scale = _pitch_scale
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
