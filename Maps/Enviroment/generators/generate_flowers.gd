class_name GenerateFlowers extends Node2D

const FLOWER = preload("res://Maps/Enviroment/Plants/Flowers/flower.tscn")

@onready var node_2d: Node2D = $Node2D
@onready var area_2d: Area2D = $Area2D

#var x : int
#var y : int
@export var amount : int = 50

func _ready() -> void:
	gen()


func gen() -> void:
	while amount >= 0:
		instantiate( randi_range( -300, 300 ), randi_range( -300, 300 ) )
		amount -= 1
		#area_2d.


func instantiate( x : int, y : int ) -> void:
	var instance : Node2D = FLOWER.instantiate()
	node_2d.add_child( instance )
	instance.position.x = x
	instance.position.y = y
	pass 
