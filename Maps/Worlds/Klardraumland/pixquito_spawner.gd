class_name PixquitoSpawner extends Node2D

const PIXQUITO = preload("uid://ba5e5f3bpk8i3")


func _ready() -> void:
	count()


func count() -> void:
	if get_children().size() < 32:
		spawn()
	await get_tree().create_timer( 2 ).timeout
	count()


func spawn() -> void:
	var new_pixquito : Pixquitoe = PIXQUITO.instantiate()
	add_child( new_pixquito )
	new_pixquito.initialize()
