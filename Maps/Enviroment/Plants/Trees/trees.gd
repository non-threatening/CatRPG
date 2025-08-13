class_name Trees extends Node2D

@onready var sprite: Trees = $"."

var png_dir : String = "res://Maps/Enviroment/Plants/Trees/sprites/"
var images : Array[ String ]
var images_full = []

func _ready() -> void:
	_get_pngs( png_dir )
	#_set_time_scale()
	#_set_random_scale()
	_set_random_color()
	_set_random_motion_amount()

	images_full = images.duplicate()
	images.shuffle()
	get_shuffled_tree()
	

func _get_pngs( path ):
	var dir = DirAccess.open( path )
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if (file_name.get_extension() == "png"):
				images.append( file_name )
			file_name = dir.get_next()

func get_shuffled_tree():
	if images.is_empty():
		# Fill the flowers array again and shuffle it.
		images = images_full.duplicate()
		images.shuffle()
	var random_shuffled_tree = images.pop_front()
	_change_sprite( random_shuffled_tree )


func _change_sprite( file : String ):
	var texture = load( png_dir + file )
	sprite.texture = texture


#func _set_time_scale() -> void:
	#var set_time = randf_range( 4.0, 5.0)
	#sprite.material.set_shader_parameter( "time_scale", set_time )
#
#
#func _set_random_scale() -> void:
	#var rand = randf_range( 0.42, 0.82 )
	#var new_scale = Vector2( rand, rand ) 
	#sprite.scale = new_scale
#
#
func _set_random_color() -> void:
	var color_range : float = fmod( randf_range( (150.0/360.0), 1.0 ) + 40.0/360.0, 1.0 )
	var color1 = Color.from_hsv(
		color_range, 
		randf_range( 0.8, 1.0 ), 
		randf_range( 0.8, 1.0 )
	)
	sprite.material.set_shader_parameter( "color1", color1 )
	#
	#
#func _set_random_stem_color() -> void:
	#var stem_color = Color.from_hsv(
		#randf_range( (120.0/360.0), (128.0/360.0) ), 
		#randf_range( 0.6, 0.9 ), 
		#randf_range( 0.6, 0.9 )
	#)
	#sprite.material.set_shader_parameter( "stem_color", stem_color )
#
#
func _set_random_motion_amount() -> void:
	var x = randf_range( 6.0, 9.0 )
	var y = randf_range( 500, 900.0 )
	var z = randf_range( 0.4, 0.6 )
	sprite.material.set_shader_parameter( "amplitude", x )
	sprite.material.set_shader_parameter( "frequency", y )
	sprite.material.set_shader_parameter( "speed", z)
