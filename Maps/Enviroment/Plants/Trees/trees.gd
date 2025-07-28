class_name Trees extends Node2D

@onready var sprite: Trees = $"."

var png_dir : String = "res://Maps/Enviroment/Plants/Trees/sprites/"


func _ready() -> void:
	_get_pngs( png_dir )
	#_set_time_scale()
	#_set_random_scale()
	#_set_random_color()
	#_set_random_motion_amount()


func _get_pngs( path ):
	var images : Array[ String ]
	var dir = DirAccess.open( path )
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if (file_name.get_extension() == "png"):
				images.append( file_name )
			file_name = dir.get_next()
	_change_sprite( images[ randi_range( 0, images.size() - 1 ) ] )


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
#func _set_random_color() -> void:
	#var color_range : float = fmod( randf_range( (250.0/360.0), 1.0 ) + 40.0/360.0, 1.0 )
	#print(color_range)
	#var petal_color = Color.from_hsv(
		#color_range, 
		#randf_range( 0.8, 1.0 ), 
		#randf_range( 0.8, 1.0 )
	#)
	#sprite.material.set_shader_parameter( "petal_color", petal_color )
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
#func _set_random_motion_amount() -> void:
	#var x = randf_range( 3.0, 5.0 )
	#var y = randf_range( 0.6, 2.0 )
	#sprite.material.set_shader_parameter( "x", x )
	#sprite.material.set_shader_parameter( "y", y )
