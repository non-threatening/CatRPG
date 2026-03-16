class_name Trees extends Node2D

const TREES_DREAM = preload("uid://bqesrg18iwyem")

const TREES = preload("uid://c6n83nrhuenne")
var png_dir : String = "res://Maps/Enviroment/Plants/Trees/sprites/"
var images : Array[ String ]
var images_full = []

@onready var area_2d : Area2D = $"../Area2D"
@onready var sprite : Trees = $"."


func _ready() -> void:
	_get_pngs( png_dir )
	images_full = images.duplicate()
	images.shuffle()
	get_shuffled_tree()	
	_set_random_scale()
	_set_random_motion_amount()
	_set_steps()
	
	var is_lobby = get_tree().get_current_scene().name
	if is_lobby == "TheLobby":
		sprite.material.shader = TREES_DREAM
		_dream_tree()
	else:
		sprite.material.shader = TREES
		_tree()


func _tree() -> void:
	sprite.material.set_shader_parameter( "color1", Color( 0.35, 0.57, 0.17, 1.0 ) )
	sprite.material.set_shader_parameter( "color2", Color( 0.49, 0.48, 0.10, 1.0 ) )
	sprite.material.set_shader_parameter( "color3", Color( 0.37, 0.21, 0.02, 1.0 ) )


func _dream_tree() -> void:
	sprite.material.set_shader_parameter( "color1", Color(0.047, 0.561, 0.0, 0.666) )
	sprite.material.set_shader_parameter( "color2", Color(0.067, 0.69, 0.0, 0.666) )
	sprite.material.set_shader_parameter( "color3", Color( 0.35, 0.99, 0.33, 0.74 ) )


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
		images = images_full.duplicate()
		images.shuffle()
	var random_shuffled_tree = images.pop_front()
	var texture = load( png_dir + random_shuffled_tree )
	sprite.texture = texture



func _set_random_scale() -> void:
	var rand = randf_range( 1.5, 2.0 )
	var new_scale = Vector2( rand, rand ) 
	var flip = randi() % 2
	sprite.flip_h = flip
	sprite.scale = new_scale
	

func _set_steps() -> void:
	var rand1 = randf_range( 0.0, 0.15 )
	var rand2 = randf_range( 0.18, 0.225 )
	sprite.material.set_shader_parameter( "step1", rand1 )
	sprite.material.set_shader_parameter( "step2", rand2 )


func _set_random_motion_amount() -> void:
	var x = randf_range( 4.0, 5.0 )
	var y = randf_range( 400.0, 600.0 )
	var z = randf_range( 0.4, 0.5 )
	sprite.material.set_shader_parameter( "amplitude", x )
	sprite.material.set_shader_parameter( "frequency", y )
	sprite.material.set_shader_parameter( "speed", z)
