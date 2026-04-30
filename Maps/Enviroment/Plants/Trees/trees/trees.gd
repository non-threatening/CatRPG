class_name Trees extends Node2D

const png_dir : String = "res://Maps/Enviroment/Plants/Trees/sprites/"
var packed_array = ResourceLoader.list_directory( png_dir )
var images : Array[ String ]
var images_full = []

@onready var area_2d : Area2D = $"../Area2D"


func _ready() -> void:
	images = Array( Array(packed_array), TYPE_STRING, "", null )
	images_full = images.duplicate()
	images.shuffle()
	get_shuffled_tree()	
	_set_random_scale()
	_set_random_motion_amount()
	_set_steps()


#func _tree() -> void:
	#material.set_shader_parameter( "color1", Color( 0.35, 0.57, 0.17, 1.0 ) )
	#material.set_shader_parameter( "color2", Color( 0.49, 0.48, 0.10, 1.0 ) )
	#material.set_shader_parameter( "color3", Color( 0.37, 0.21, 0.02, 1.0 ) )


func get_shuffled_tree():
	if images.is_empty():
		images = images_full.duplicate()
		images.shuffle()
	var random_shuffled_tree = images.pop_front()
	var texture = load( png_dir + random_shuffled_tree )
	self.texture = texture



func _set_random_scale() -> void:
	var rand = randf_range( 1.25, 1.5 )
	var new_scale = Vector2( rand, rand )
	var flip = randi() % 2
	self.flip_h = flip
	scale = new_scale
	

func _set_steps() -> void:
	var rand1 = randf_range( 0.0, 0.15 )
	var rand2 = randf_range( 0.18, 0.225 )
	material.set_shader_parameter( "step1", rand1 )
	material.set_shader_parameter( "step2", rand2 )


func _set_random_motion_amount() -> void:
	var x = randf_range( 4.0, 5.0 )
	var y = randf_range( 400.0, 600.0 )
	var z = randf_range( 0.4, 0.5 )
	material.set_shader_parameter( "amplitude", x )
	material.set_shader_parameter( "frequency", y )
	material.set_shader_parameter( "speed", z)
