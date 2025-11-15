class_name FlowerSpawnerKTL extends Node2D

#const FLOWER = preload("uid://bll4i550rlr37")
const PLANT = preload("uid://7y3rydpf6bjk")


func _ready() -> void:
	count()


func count() -> void:
	if get_children().size() < 32:
		spawn()
	await get_tree().create_timer( 1 ).timeout
	count()


func spawn() -> void:
	var new_flower : Plant = PLANT.instantiate()
	add_child( new_flower )
	new_flower.initialize()
