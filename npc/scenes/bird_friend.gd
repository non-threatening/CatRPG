@icon( "res://npc/icons/npc.svg" )
class_name BirdFriend extends Node2D

@onready var bird_friend: BirdFriend = $"."

func _ready() -> void:
	NpcManager.bf_npc_status.connect( _status )
	bird_friend.hide()


func _status( awake, location ) -> void:
	prints( "awake", awake, location )
	if awake:
		var thing = get_tree().get_current_scene().name
		if location == thing:
			bird_friend.show()
		prints(thing)
	else:
		bird_friend.hide()
