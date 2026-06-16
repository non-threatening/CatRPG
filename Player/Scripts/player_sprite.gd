extends Sprite2D

const PLAYER_SHADER = preload("uid://b4d5u50y4e3og")
const PLAYER_LOKTIN = preload("uid://b3iybtj0bph5k")

@onready var player : Player = $".."
@onready var sprite: Sprite2D = $"."
@onready var shadow_sprite: Sprite2D = $ShadowSprite
@onready var bird_friend_sprite: Sprite2D = $BirdFriendSprite
@onready var player_shape_hor: CollisionShape2D = $"../PlayerShapeHor"
@onready var player_shape_vert: CollisionShape2D = $"../PlayerShapeVert"
@onready var footprints: Node2D = $footprints


var cur_dur

var minute : int = 0
var hour : int = 0
var minutes : int = 0

func _ready() -> void:
	LevelManager.level_loaded.connect( _check_level )
	player.DirectionChanged.connect( _on_direction_changed )
	TimeSystem.time_tick.time_unit_changed.connect( time_display )
	eye_color()


func time_display(unit_name: String, new_value: int, old_value: int) -> void:
	match unit_name:
		"hour":
			hour = new_value
		"minute":
			minute = new_value
			eye_color()


func eye_color() -> void:
	## CavasModulate
	minutes = hour * 60 + minute
	var darkness = fmod( remap( minutes, 1.0, 1440.0, 0.0, 360.0 ), 360 )
	#day
	if darkness >= 0 and darkness < 90:
		if darkness <= 49:
			sprite.material.set_shader_parameter( "eye_color", Color(1.7, 1.7, 1.7, 1.0) )
		elif darkness > 50:
			#40 steps, eyes turning black
			sprite.material.set_shader_parameter( "eye_color", 
				Color( 
					(darkness - 90) * -0.04 + 0.118, 
					(darkness - 90) * -0.04 + 0.118, 
					(darkness - 90) * -0.04 + 0.118,
					1.0 ) )
	#steady black
	elif darkness > 90 and darkness < 270:
		sprite.material.set_shader_parameter( "eye_color", Color(0.125, 0.125, 0.125, 1.0) )
		
	#night
	elif darkness > 270 and darkness < 360:
		if darkness < 312:
			#eyes turning white
			sprite.material.set_shader_parameter( "eye_color", 
				Color(
					(darkness - 270) * 0.04,
					(darkness - 270) * 0.04,
					(darkness - 270) * 0.04,
					1.0 ) )
		elif darkness >= 313:
			sprite.material.set_shader_parameter( "eye_color", Color(1.7, 1.7, 1.7, 1.0) )


func _check_level() -> void:
	await tree_entered
	var thing = get_tree().get_current_scene().name
	# prints("check level:", thing)
	if thing.begins_with("arel"):
		print("YES!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
		pass
	match thing:
		"TheLobby":
			sprite.material.shader = PLAYER_LOKTIN
		_:
			sprite.material.shader = PLAYER_SHADER


func _on_direction_changed( new_dir : Vector2 ):
	bird_friend_sprite.show_behind_parent = false
	cur_dur = new_dir
	match new_dir:
		Vector2.DOWN:
			bird_friend_sprite.position = Vector2( -8, -153 )
			bird_friend_sprite.show_behind_parent = true
			
			player_shape_vert.set_deferred( "disabled", false )
			player_shape_hor.set_deferred( "disabled", true )
			
			footprints.rotation_degrees = 90
		Vector2.UP:
			bird_friend_sprite.position = Vector2( -10, -164 )
			
			player_shape_vert.set_deferred( "disabled", false )
			player_shape_hor.set_deferred( "disabled", true )
			
			footprints.rotation_degrees = 90
		Vector2.LEFT, Vector2.RIGHT:
			bird_friend_sprite.position = Vector2( -50, -145 )
			
			player_shape_vert.set_deferred( "disabled", true )
			player_shape_hor.set_deferred( "disabled", false )
			
			footprints.rotation = 0
		_:
			pass
