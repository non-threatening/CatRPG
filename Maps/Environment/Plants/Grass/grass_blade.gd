class_name GrassBlade extends Node2D

@onready var sprite : GrassBlade = $"."

var png_dir : String = "res://Maps/Environment/Plants/Grass/sprites/"


func _ready() -> void:
	_get_pngs( png_dir )
	_set_time_scale()
	_set_random_scale()
	_set_random_color()
	_set_random_motion_amount()


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


func _set_time_scale() -> void:
	var set_time = randf_range( 1.5, 2.8)
	sprite.material.set_shader_parameter( "time_scale", set_time )


func _set_random_scale() -> void:
	var rand = randf_range( 0.1, 0.2 )
	var new_scale = Vector2( rand, rand ) 
	sprite.scale = new_scale


func _set_random_color() -> void:
	var new_color = Color.from_hsv(
		randf_range( (115.0/360.0), (122.0/360.0) ), 
		randf_range( 0.6, 0.8 ), 
		randf_range( 0.3, 0.4 )
	)
	sprite.material.set_shader_parameter( "new_color", new_color )


func _set_random_motion_amount() -> void:
	var x = randi_range( 20, 30 )
	var y = randi_range( 6, 10 )
	sprite.material.set_shader_parameter( "x", x )
	sprite.material.set_shader_parameter( "y", y )
