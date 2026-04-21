@icon( "res://npc/icons/npc.svg" )
class_name BirdFriend extends Node2D

@onready var bird_friend: BirdFriend = $"."
@onready var to_and_fro: Node = $ToAndFro


func _ready() -> void:
	NpcManager.bf_npc_status.connect( _status )
	NpcManager.bf_arrive.connect( _arrived )
	LevelManager.level_loaded.connect( _on_level_loaded )


func _on_level_loaded() -> void:
	if StatsManager.achievements.have_bird_friend == 1:
		await get_tree().create_timer( 0.7 ).timeout
		if NpcManager.bf_awake == true:
			bird_friend.modulate = Color( 1, 1, 1, 0 )
			bird_friend.show()
			var tween : Tween = create_tween()
			tween.tween_property( bird_friend, "modulate", Color( 1, 1, 1, 1 ), 1.0 )
	else:
		bird_friend.hide()


func _arrived() -> void:
	bird_friend.show()


func _status( awake, location ) -> void:
	if awake:
		var current_scene = get_tree().get_current_scene().name
		if location == current_scene:
			to_and_fro.bird_arriving()
	else:
		to_and_fro.bird_leaving_to_and_fro()
		bird_friend.hide()
