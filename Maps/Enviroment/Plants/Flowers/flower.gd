class_name Flower extends Node2D

const FLOWER_DREAM = preload("uid://c5ovupdrrtgpr")
const FLOWER_MATERIAL = preload("uid://bbj3feg1ntecx")
const png_dir : String = "res://Maps/Enviroment/Plants/Flowers/sprites/"
var packed_array = ResourceLoader.list_directory( png_dir )
var images : Array[ String ]
var images_full = []

@onready var flower: Node2D = $".."


func _ready() -> void:
	images = Array( Array(packed_array), TYPE_STRING, "", null )
	images_full = images.duplicate()
	images.shuffle()
	get_shuffled_flower()
	_set_time_scale()
	_set_random_scale()
	
	var is_lobby = get_tree().get_current_scene().name
	if is_lobby == "TheLobby":
		material.shader = FLOWER_DREAM
	else:
		material.shader = FLOWER_MATERIAL
		_set_random_color()
		
	_set_random_motion_amount()


func get_shuffled_flower():
	if images.is_empty():
		images = images_full.duplicate()
		images.shuffle()
	var random_flower = images.pop_front()
	var texture = load( png_dir + random_flower )
	self.texture = texture


func _set_time_scale() -> void:
	var set_time = randf_range( 4.0, 5.0)
	material.set_shader_parameter( "time_scale", set_time )


func _set_random_scale() -> void:
	var rand = randf_range( 0.48, 0.8 )
	var new_scale = Vector2( rand, rand )
	var flip = randi() % 2
	self.flip_h = flip
	scale = new_scale


func _set_random_motion_amount() -> void:
	var x = randf_range( 3.0, 5.0 )
	var y = randf_range( 2.5, 3.5 )
	material.set_shader_parameter( "x", x )
	material.set_shader_parameter( "y", y )


func _set_random_color() -> void:
	var color_range1 : float = fmod( randf_range( (290.0/360.0), 1.0 ) + 50.0/360.0, 1.0 )
	var color1 = Color.from_hsv(
		color_range1, 
		randf_range( 0.6, 0.8 ), 
		randf_range( 0.8, 1.0 )
	)
	material.set_shader_parameter( "color1", color1 )
