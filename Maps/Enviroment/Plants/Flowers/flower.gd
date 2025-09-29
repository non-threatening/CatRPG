class_name Flower extends Node2D

@onready var sprite: Flower = $"."

var png_dir : String = "res://Maps/Enviroment/Plants/Flowers/sprites/"
var images : Array[ String ]
var images_full = []

func _ready() -> void:
	_get_pngs()
	
	images_full = images.duplicate()
	images.shuffle()
	get_shuffled_flower()
	
	_set_time_scale()
	_set_random_scale()
	_set_random_color()
	_set_random_motion_amount()
	pass


func _get_pngs():
	var dir = DirAccess.open( png_dir )
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
##TODO: wierd work around to get pngs to load in exported game
			#if ResourceLoader.exists(file_name.get_extension() == "png"):
			if (file_name.get_extension() == "import"):
				file_name = file_name.replace('.import', '')
				images.append( file_name )
			file_name = dir.get_next()


func get_shuffled_flower():
	if images.is_empty():
		images = images_full.duplicate()
		images.shuffle()
	var random_flower = images.pop_front()
	var texture = load( png_dir + random_flower )
	sprite.texture = texture


func _set_time_scale() -> void:
	var set_time = randf_range( 4.0, 5.0)
	sprite.material.set_shader_parameter( "time_scale", set_time )


func _set_random_scale() -> void:
	var rand = randf_range( 0.48, 0.82 )
	var new_scale = Vector2( rand, rand )
	var flip = randi() % 2
	sprite.flip_h = flip
	sprite.scale = new_scale


func _set_random_color() -> void:
	var color_range1 : float = fmod( randf_range( (270.0/360.0), 1.0 ) + 50.0/360.0, 1.0 )
	var color1 = Color.from_hsv(
		color_range1, 
		randf_range( 0.6, 0.8 ), 
		randf_range( 0.8, 1.0 )
	)
	sprite.material.set_shader_parameter( "color1", color1 )

	
	
func _set_random_stem_color() -> void:
	var stem_color = Color.from_hsv(
		randf_range( (120.0/360.0), (133.0/360.0) ), 
		randf_range( 0.6, 0.9 ), 
		randf_range( 0.45, 0.6 )
	)
	sprite.material.set_shader_parameter( "stem_color", stem_color )


func _set_random_motion_amount() -> void:
	var x = randf_range( 3.0, 5.0 )
	var y = randf_range( 2.5, 3.5 )
	sprite.material.set_shader_parameter( "x", x )
	sprite.material.set_shader_parameter( "y", y )
