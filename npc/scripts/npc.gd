@tool
@icon( "res://npc/icons/npc.svg" )
class_name NPC extends CharacterBody2D

@export var npc_resource : NPCResource : set = _set_npc_resourse ## npc .tres file

@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	setup_npc()


func _physics_process( _delta: float ) -> void:
	move_and_slide()


func setup_npc() -> void:
	if npc_resource:
		prints( "npc resource", npc_resource.npc_name )


func _set_npc_resourse( _npc : NPCResource ) -> void:
	npc_resource = _npc
	setup_npc()
