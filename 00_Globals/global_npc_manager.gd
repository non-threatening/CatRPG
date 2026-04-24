extends Node
@warning_ignore_start("unused_signal")

signal bf_npc_status()
signal bf_away # triggered in dialog
signal bf_arrive

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
	await get_tree().create_timer( 0.666 ).timeout
	match TimeSystem.hour:
		5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16:
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


func bye_bye_bird_friend() -> void:
	await get_tree().create_timer( randi() % 20 ).timeout
	if StatsManager.achievements.have_bird_friend == 1:
		if PlayerHud.current_friend == 1:
			## make sure bird friend is sitting on the player and we're not in a minigame
			if PlayerManager.player.bird_friend_sprite.visible == true:
				if not str(PlayerManager.player.state_machine.current_state).contains( "freq" ):
					_start_dialog( SPEACH_BUBBLE, BF_REPEATABLES, "goodbyes" )
					PlayerHud.update_ability_ui( 0 ) # NONE
				else:
					await get_tree().create_timer( 1 ).timeout
					bye_bye_bird_friend()
		else:
			##	Then it's in the tree and flies away; bird_friend.gd
			bf_awake = false
			bf_npc_status.emit( bf_awake, null )


func bird_friend_awake() -> void:
	await get_tree().create_timer( randi() % 20 ).timeout
	if StatsManager.achievements.have_bird_friend:
		if PlayerHud.current_friend != 1:
			var location : String
			bf_awake = true
			#	Every three days
			var day : int = int( (TimeSystem.day + 3 ) / 3.0 ) % 3 == 0
			match day:
				0:
					location = "GrassTestMap"
				_:
					location = "GrassTestMap"
			bf_npc_status.emit( bf_awake, location )



func _start_dialog( bubble, resourse, cue) -> void:
	speech_bubble = bubble.instantiate()
	get_tree().current_scene.add_child(speech_bubble)
	speech_bubble.start( resourse, cue )
