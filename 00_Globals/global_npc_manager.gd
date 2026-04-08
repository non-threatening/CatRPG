extends Node

@warning_ignore_start("unused_signal")
signal bf_npc_status()
signal bf_away

const BF_REPEATABLES = preload("uid://cfyfqaq8el1xq")

const LOKTIN_BUBBLE = preload("uid://bym1e6q2jq1c2")
const SPEACH_BUBBLE = preload("uid://c0u3mmda127cd")
const TERMINAL_BUBBLE = preload("uid://cxp6nsydpp02j")

var speech_bubble : Node

var bf_awake : bool = true


func _ready() -> void:
	TimeSystem.time_tick.time_unit_changed.connect( _on_time_unit_changed )
	_on_time_unit_changed


func _on_time_unit_changed(unit_name: String, new_value: int, old_value: int) -> void:
	match unit_name:
		"hour":
			match new_value:
				5:
					bird_friend_awake()
				17:
					match TimeSystem.moon:
						3, 4, 5:
							bye_bye_bird_friend()
				13:
					bye_bye_bird_friend()
				16:
					bird_friend_awake()
				17:
					bye_bye_bird_friend()
				20:
					bird_friend_awake()
				_:
					pass


func bye_bye_bird_friend() -> void:
	bf_awake = false
	if PlayerHud.current_friend == 1:
		_start_dialog( SPEACH_BUBBLE, BF_REPEATABLES, "goodbyes" )
		PlayerHud.update_ability_ui( 0 ) # NONE
		prints("Bird Friend goes away")
	else:
		bf_npc_status.emit( bf_awake, null )
		

func bird_friend_awake() -> void:
	if PlayerHud.current_friend != 1:
		var location : String
		bf_awake = true
		#	Every three days
		if int( (TimeSystem.day + 3 ) / 3.0 ) % 3 == 0:
			location = "GrassTestMap"
		else:
			location = "GrassTestMap"
		bf_npc_status.emit( bf_awake, location )


func _start_dialog( bubble, resourse, cue) -> void:
	speech_bubble = bubble.instantiate()
	get_tree().current_scene.add_child(speech_bubble)
	speech_bubble.start( resourse, cue )
