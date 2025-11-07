class_name PixquitoSpawner extends Node2D

const PIXQUITO = preload("uid://ba5e5f3bpk8i3")

@onready var pixquitoes: Node2D = $"."


func _ready() -> void:
	count()


func count() -> void:
	if pixquitoes.get_children().size() < 50:
		spawn()
	await get_tree().create_timer( 5 ).timeout
	count()


func spawn() -> void:
	var new_pixquito : Pixquitoe = PIXQUITO.instantiate()
	pixquitoes.add_child( new_pixquito )
	new_pixquito.initialize()
