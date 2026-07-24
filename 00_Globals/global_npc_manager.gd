extends Node
@warning_ignore_start("unused_signal")

signal bf_npc_status()
signal bf_away # triggered in dialog
signal bf_arrive
signal bf_return

signal bat_npc_status()
signal bat_away # triggered in dialog
signal bat_arrive
signal bat_return

const BF_REPEATABLES = preload("uid://cfyfqaq8el1xq")
const BAT_REPEATABLES = preload("uid://biewkjvvfbx8j")

const SPEECH_BUBBLE = preload("uid://c0u3mmda127cd")

var speech_bubble : Node
var bf_awake : bool = true
var bat_awake : bool = true


func _ready() -> void:
	TimeSystem.time_tick.time_unit_changed.connect( _on_time_unit_changed )
	LevelManager.level_loaded.connect( _on_level_loaded )


func _on_level_loaded() -> void:
	await get_tree().create_timer( 1.0 ).timeout
	match TimeSystem.hour:
		5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17:
			bf_awake = true
			bat_awake = false
		18:
			bat_awake = true
			match TimeSystem.moon:
				0, 1, 2, 6, 7:
					bf_awake = false
		19:
			bat_awake = true
			match TimeSystem.moon:
				3, 4, 5:
					bf_awake = false
		20, 21, 22, 23, 0, 1, 2, 3, 4:
			bf_awake = false
			bat_awake = true
		_:
			pass


func _on_time_unit_changed(unit_name: String, new_value: int, old_value: int) -> void:
	match unit_name:
		"hour":
			match new_value:
				5:
					bird_friend_awake()
					bye_bye_bat_friend()
				18:
					bat_friend_awake()
					match TimeSystem.moon:
						0, 1, 2, 6, 7:
							bye_bye_bird_friend()
				19:
					match TimeSystem.moon:
						3, 4, 5:
							bye_bye_bird_friend() ## stays out later when full moon
				_:
					pass


func _standard_checks() -> bool:
	if PauseMenu.visible == false:
		if not str(PlayerManager.player.state_machine.current_state).contains( "freq" ):
			return true
	return false

func set_none() -> void:
	PlayerManager.player.player_friends.friends = ["NONE", "", "", "", ""]
	PauseMenu.update_friend_items( ["NONE", "", "", "", ""] )
	PlayerManager.player.player_friends.set_friend_number( 0 )
	prints("set none")


## Bird Friend
func _bye_bird_friend_checks() -> bool:
	if _standard_checks():
		if PlayerManager.player.bird_friend_sprite.visible == true: # ex. not in STATE.THROW
			return true
	# keeps looping if it can't fly away, delay in func
	bye_bye_bird_friend()
	return false

func bye_bye_bird_friend() -> void:
	await get_tree().create_timer( ( randi() + 1 ) % 18 ).timeout
	## If we have bird friend and she's is our current friend, then trigger dialog
	if PlayerManager.player.player_friends.selected_friend == 1:
		if _bye_bird_friend_checks():
			_start_dialog( SPEECH_BUBBLE, BF_REPEATABLES, "goodbyes" )
			set_none()
	else:
		##	or else it's in the tree and flies away. -bird_friend.gd
		bf_awake = false
		bf_npc_status.emit( bf_awake, null )

func bird_friend_awake() -> void:
	await get_tree().create_timer( ( randi() + 1) % 18 ).timeout
	##	flies back to the tree if we're friends and it's not the selected friend
	if StatsManager.achievements.have_bird_friend == 1:
		if PlayerManager.player.player_friends.selected_friend != 1:
			var location : String
			bf_awake = true
			#	Every three days
			var day : int = int( TimeSystem.day + 3 ) % 3
			match day:
				0:
					location = "GrassTestMap"
				_:
					location = "ArelCrashSite"
			bf_npc_status.emit( bf_awake, location )
	else:
		pass



## Bat Friend
func _bye_bat_friend_checks() -> bool:
	if _standard_checks():
		if PlayerManager.player.bat_friend_sprite.visible == true: # ex. not in STATE.THROW
			return true
		elif PlayerManager.player.player_friends.selected_friend != 5:
			return true
	# keeps looping if it can't fly away, delay in func
	bye_bye_bat_friend()
	return false

func bye_bye_bat_friend() -> void:
	await get_tree().create_timer( ( randi() + 1 ) % 5 ).timeout
	## If we have bat friend and she's is our current friend, then trigger dialog
	if PlayerManager.player.player_friends.selected_friend == 5:
		if _bye_bat_friend_checks():
			_start_dialog( SPEECH_BUBBLE, BAT_REPEATABLES, "goodbyes" )
			#set_none()
	else:
		##	or else it's in the tree and flies away. -bat_friend.gd
		bat_awake = false
		bat_npc_status.emit( bat_awake, null )

func bat_friend_awake() -> void:
	await get_tree().create_timer( ( randi() + 1) % 8 ).timeout
	bat_awake = true
	##flies back to tree if we're friends and it's not the selected friend, or not friends at all
	if StatsManager.achievements.have_bat_friend == 1:
		if PlayerManager.player.player_friends.selected_friend != 5:
			bat_npc_status.emit( bat_awake, "GrassTestMap" )
	else:
		bat_npc_status.emit( bat_awake, "GrassTestMap" )



func _start_dialog( bubble, resourse, cue) -> void:
	speech_bubble = bubble.instantiate()
	get_tree().current_scene.add_child(speech_bubble)
	speech_bubble.start( resourse, cue )
