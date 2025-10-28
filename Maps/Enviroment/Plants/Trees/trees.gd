class_name Trees extends Node2D

const DREAM_TREE = preload( "res://Maps/Enviroment/Plants/Trees/trees_dream.gdshader" )
const TREES = preload("uid://c6n83nrhuenne")


@onready var sprite: Trees = $"."

var png_dir : String = "res://Maps/Enviroment/Plants/Trees/sprites/"
var images : Array[ String ]
var images_full = []

func _ready() -> void:
	_get_pngs( png_dir )
	images_full = images.duplicate()
	images.shuffle()
	get_shuffled_tree()	
	var is_lobby = get_tree().get_current_scene().name
	if is_lobby == "TheLobby":
		sprite.material.shader = DREAM_TREE
	else:
		sprite.material.shader = TREES
		_set_steps()

	_set_random_scale()
	_set_random_motion_amount()


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
	var rand = randf_range( 0.86, 1.0 )
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
