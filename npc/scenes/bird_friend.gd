@icon( "res://npc/icons/npc.svg" )
class_name BirdFriend extends Node2D

#@export

var wait_time: float = 1.0
var time: float = 0.0

@onready var bird_friend: BirdFriend = $"."
@onready var to_and_fro: Node = $ToAndFro
@onready var sprite: Sprite2D = $Npc/Sprite2D

@onready var indicator_2d: InteractIndicator = $Indicator2D
@onready var actionable_dialog: Area2D = $ActionableDialog


func _ready() -> void:
	NpcManager.bf_npc_status.connect( _status )
	NpcManager.bf_arrive.connect( _arrived )
	NpcManager.bf_return.connect( _back_to_cat )
	LevelManager.level_loaded.connect( _on_level_loaded )
	actionable_dialog.monitorable = false
	indicator_2d.monitorable = false


func _on_level_loaded() -> void:
	if StatsManager.achievements.have_bird_friend == 1:
		await get_tree().create_timer( 1.2 ).timeout
		##	If BF is awake and 
		if NpcManager.bf_awake == true and PlayerManager.player.player_friends.selected_friend != 1:
			bird_friend.modulate = Color( 1, 1, 1, 0 )
			_arrived()
			var tween : Tween = create_tween()
			tween.tween_property( bird_friend, "modulate", Color( 1, 1, 1, 1 ), 0.666 )
	else:
		bird_friend.hide()
		actionable_dialog.monitorable = false
		indicator_2d.monitorable = false


func _arrived() -> void:
	bird_friend.show()
	actionable_dialog.monitorable = true
	indicator_2d.monitorable = true


func _back_to_cat() -> void:
	to_and_fro.to_and_fro_back_to_cat()
	bird_friend.hide()
	PlayerManager.player.player_friends.friends = ["", "BIRD", "", "", ""]
	PlayerManager.player.player_friends.set_friend_number( 1 )
	PauseMenu.update_friend_items( ["", "BIRD", "", "", ""] )


## Back and forth from tree
func _status( awake, location ) -> void:
	prints("bf awake, location:", awake, location)
	if awake:
		var current_scene = get_tree().get_current_scene().name
		if location == current_scene:
			to_and_fro.bird_arriving()
	else:
		to_and_fro.bird_leaving_to_and_fro()
		bird_friend.hide()


func _process( _delta: float ) -> void:
	if bird_friend.visible == true:
		time += _delta
		if time >= wait_time:
			time -= wait_time
			sprite.frame = randi() % 2
			wait_time = randi_range( 1, 5 )
