class_name Flower extends Node2D

const FLOWER_DREAM = preload("uid://c5ovupdrrtgpr")
const FLOWER_MATERIAL = preload("uid://bbj3feg1ntecx")
const png_dir : String = "res://Maps/Enviroment/Plants/Flowers/sprites/"

var images : Array[ String ]
var images_full = []

@onready var sprite: Flower = $"."
@onready var shadow_sprite: Sprite2D = $ShadowSprite
@onready var shadow_sprite_green: Sprite2D = $ShadowSpriteGreen


func _ready() -> void:
	_get_pngs()
	images_full = images.duplicate()
	images.shuffle()
	get_shuffled_flower()
	_set_time_scale()
	_set_random_scale()
	var is_lobby = get_tree().get_current_scene().name
	if is_lobby == "TheLobby":
		sprite.material.shader = FLOWER_DREAM
		shadow_sprite.hide()
		shadow_sprite_green.show()
	else:
		sprite.material.shader = FLOWER_MATERIAL
		_set_random_color()
		shadow_sprite.show()
		shadow_sprite_green.hide()
		
	_set_random_motion_amount()
	pass


func _get_pngs():
	var dir = DirAccess.open( png_dir )
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
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
	var rand = randf_range( 0.48, 0.8 )
	var new_scale = Vector2( rand, rand )
	var flip = randi() % 2
	sprite.flip_h = flip
	sprite.scale = new_scale


func _set_random_motion_amount() -> void:
	var x = randf_range( 3.0, 5.0 )
	var y = randf_range( 2.5, 3.5 )
	sprite.material.set_shader_parameter( "x", x )
	sprite.material.set_shader_parameter( "y", y )


func _set_random_color() -> void:
	var color_range1 : float = fmod( randf_range( (270.0/360.0), 1.0 ) + 50.0/360.0, 1.0 )
	var color1 = Color.from_hsv(
		color_range1, 
		randf_range( 0.6, 0.8 ), 
		randf_range( 0.8, 1.0 )
	)
	sprite.material.set_shader_parameter( "color1", color1 )
