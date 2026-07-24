@icon( "res://npc/icons/npc.svg" )
class_name BatFriend extends Node2D

const BAT_REPEATABLES = preload("uid://biewkjvvfbx8j")
const MEETING_BAT_FRIEND = preload("uid://b8f7b6bx6l2pn")

var wait_time: float = 1.0
var time: float = 0.0

@onready var bat_friend: Node2D = $"."

@onready var sprite: Sprite2D = $Npc/Sprite2D
@onready var to_and_fro_bat: ToAndFromBat = $ToAndFro
@onready var indicator_2d: InteractIndicator = $Indicator2D
@onready var actionable_dialog: Area2D = $ActionableDialog


func _ready() -> void:
	NpcManager.bat_npc_status.connect( _status )
	NpcManager.bat_arrive.connect( _arrived )
	NpcManager.bat_return.connect( _back_to_cat )
	LevelManager.level_loaded.connect( _on_level_loaded )
	actionable_dialog.monitorable = false
	indicator_2d.monitorable = false


func _on_level_loaded() -> void:
	bat_friend.hide()
	if StatsManager.achievements.have_bat_friend == 1:
		actionable_dialog.dialogue_resource = BAT_REPEATABLES
		await get_tree().create_timer( 1.2 ).timeout
		if NpcManager.bat_awake == true and PlayerManager.player.player_friends.selected_friend != 5:
			bat_friend.modulate = Color( 1, 1, 1, 0 )
			_arrived()
			var tween : Tween = create_tween()
			tween.tween_property( bat_friend, "modulate", Color( 1, 1, 1, 1 ), 0.666 )
	else:
		### if we're not friends yet he needs to be there
		_arrived()
		actionable_dialog.dialogue_resource = MEETING_BAT_FRIEND
	prints("actionable", actionable_dialog.dialogue_resource)



func _arrived() -> void:
	bat_friend.show()
	actionable_dialog.monitorable = true
	indicator_2d.monitorable = true
	if StatsManager.achievements.have_bat_friend == 1:
		actionable_dialog.dialogue_resource = BAT_REPEATABLES
		actionable_dialog.dialogue_start = "in_tree"


func _back_to_cat() -> void:
	to_and_fro_bat.to_and_fro_back_to_cat()
	bat_friend.hide()
	actionable_dialog.monitorable = false
	indicator_2d.monitorable = false
	PlayerManager.player.player_friends.friends = ["", "", "", "", "", "BAT"]
	PlayerManager.player.player_friends.set_friend_number( 5 )
	PauseMenu.update_friend_items( ["", "", "", "", "", "BAT"] )


## Back and forth from tree
func _status( awake, location ) -> void:
	prints("bat awake, location:", awake, location)
	if awake:
		var current_scene = get_tree().get_current_scene().name
		if location == current_scene:
			to_and_fro_bat.bat_arriving()
	else:
		prints("hide bat, trigger bat_leaving_toAnd_fro")
		to_and_fro_bat.bat_leaving_to_and_fro()
		bat_friend.hide()


#func _process( _delta: float ) -> void:
	#if bat_friend.visible == true:
		#time += _delta
		#if time >= wait_time:
			#time -= wait_time
			#sprite.frame = randi() % 2
			#wait_time = randi_range( 1, 5 )
