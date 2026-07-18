class_name Mushroom extends Node2D

const png_dir : String = "res://Maps/Enviroment/Plants/mushrooms/sprites/"

var packed_array = ResourceLoader.list_directory( png_dir )
var images : Array[ String ]
var images_full = []

var x : float = 0
var y : float = 0

func _ready() -> void:
	SignalBus.desaturate.connect( desat )
	images = Array( Array(packed_array), TYPE_STRING, "", null )
	images_full = images.duplicate()
	images.shuffle()
	get_shuffled_flower()
	_set_time_scale()
	_set_random_color()
	_set_random_motion_amount()
	_set_random_scale()


func desat( _value ) -> void:
	material.set_shader_parameter( "saturation", _value )
	

func get_shuffled_flower():
	if images.is_empty():
		images = images_full.duplicate()
		images.shuffle()
	var random_flower = images.pop_front()
	var img = load( png_dir + random_flower )
	self.texture = img

func _set_time_scale() -> void:
	var set_time = randf_range( 4.0, 5.0)
	material.set_shader_parameter( "time_scale", set_time )


func _set_random_scale() -> void:
	var rand = randf_range( 0.48, 1.0 )
	var new_scale = Vector2( rand, rand )
	var flip = randi() % 2
	self.flip_h = flip
	scale = new_scale


func _set_random_motion_amount() -> void:
	x = randf_range( 0.9, 1.1 )
	y = randf_range( 10, 15 )
	material.set_shader_parameter( "x", x )
	material.set_shader_parameter( "y", y )


func _set_random_color() -> void:
	var color_range1 : float = randf()
	var color1 = Color.from_hsv(
		color_range1,
		randf_range( 0.6, 0.8 ), 
		randf_range( 0.8, 1.0 )
	)
	material.set_shader_parameter( "color1", color1 )
	prints( "color1:", color1 )
