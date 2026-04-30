extends Node
@warning_ignore_start("unused_signal")

signal bf_npc_status()
signal bf_away # triggered in dialog
signal bf_arrive
signal bf_return

const BF_REPEATABLES = preload("uid://cfyfqaq8el1xq")

const LOKTIN_BUBBLE = preload("uid://bym1e6q2jq1c2")
const SPEACH_BUBBLE = preload("uid://c0u3mmda127cd")
const TERMINAL_BUBBLE = preload("uid://cxp6nsydpp02j")

var speech_bubble : Node
var bf_awake : bool = true


func _ready() -> void:
	TimeSystem.time_tick.time_unit_changed.connect( _on_time_unit_changed )
	LevelManager.level_loaded.connect( _on_level_loaded )


func _on_level_loaded() -> void:
	await get_tree().create_timer( 1.0 ).timeout
	match TimeSystem.hour:
		5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17:
			bf_awake = true
		18:
			match TimeSystem.moon:
				0, 1, 2, 6, 7:
					bf_awake = false
		19:
			match TimeSystem.moon:
				3, 4, 5:
					bf_awake = false
		20, 21, 22, 23, 0, 1, 2, 3, 4:
			bf_awake = false
		_:
			pass


func _on_time_unit_changed(unit_name: String, new_value: int, old_value: int) -> void:
	match unit_name:
		"hour":
			match new_value:
				5:
					bird_friend_awake()
				18:
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

func _set_none() -> void:
	PlayerManager.player.player_abilities.abilities = ["NONE", "", "", "", ""]
	PauseMenu.update_ability_items( ["NONE", "", "", "", ""] )
	PlayerManager.player.player_abilities.set_ability_number( 0 )


## Bird Friend
func _bye_bird_friend_checks() -> bool:
	if _standard_checks():
		if PlayerManager.player.bird_friend_sprite.visible == true: # not in STATE.THROW
			return true
	bye_bye_bird_friend()
	return false

func bye_bye_bird_friend() -> void:
	#await get_tree().create_timer( ( randi() + 1) % 18 ).timeout
	## If we have bird friend
	if StatsManager.achievements.have_bird_friend == 1:
		## If we have bird friend and she's is our current friend, then trigger dialog
		if PlayerManager.player.player_abilities.selected_ability == 1:
			if _bye_bird_friend_checks():
				_start_dialog( SPEACH_BUBBLE, BF_REPEATABLES, "goodbyes" )
				_set_none()
		else:
			##	or else it's in the tree and flies away. -bird_friend.gd
			bf_awake = false
			bf_npc_status.emit( bf_awake, null )

func bird_friend_awake() -> void:
	#await get_tree().create_timer( ( randi() + 1) % 18 ).timeout
	prints("Hello Bird Friend")
	if StatsManager.achievements.have_bird_friend == 1:
		if PlayerManager.player.player_abilities.selected_ability != 1:
			prints("Hello selected")
			var location : String
			bf_awake = true
			#	Every three days
			var day : int = int( (TimeSystem.day + 3 ) / 3.0 ) % 3 == 0
			match day:
				0:
					#location = "GrassTestMap"
					location = "ArelCrashSite"
				_:
					location = "ArelCrashSite"
			bf_npc_status.emit( bf_awake, location )



func _start_dialog( bubble, resourse, cue) -> void:
	speech_bubble = bubble.instantiate()
	get_tree().current_scene.add_child(speech_bubble)
	speech_bubble.start( resourse, cue )
