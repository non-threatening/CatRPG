@icon( "res://npc/icons/npc.svg" )
class_name BirdFriend extends Node2D

@onready var bird_friend: BirdFriend = $"."
@onready var to_and_fro: Node = $ToAndFro


func _ready() -> void:
	NpcManager.bf_npc_status.connect( _status )
	NpcManager.bf_arrive.connect( _arrived )
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
