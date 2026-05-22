extends Sprite2D

const PLAYER = preload("uid://b4d5u50y4e3og")
const PLAYER_LOKTIN = preload("uid://b3iybtj0bph5k")

@onready var player : Player = $".."
@onready var sprite: Sprite2D = $"."
@onready var shadow_sprite: Sprite2D = $ShadowSprite
@onready var bird_friend_sprite: Sprite2D = $BirdFriendSprite
@onready var player_shape_hor: CollisionShape2D = $"../PlayerShapeHor"
@onready var player_shape_vert: CollisionShape2D = $"../PlayerShapeVert"

var cur_dur


func _ready() -> void:
	LevelManager.level_loaded.connect( _check_level )
	player.DirectionChanged.connect( _on_direction_changed )


func _check_level() -> void:
	await tree_entered
	var thing = get_tree().get_current_scene().name
	prints(thing)
	if thing.begins_with("arel"):
		print("YES!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
		pass
	match thing:
		"TheLobby":
			sprite.material.shader = PLAYER_LOKTIN
		_:
			sprite.material.shader = PLAYER


#func _physics_process( _delta: float) -> void:
	#
	#pass


func _on_direction_changed( new_dir : Vector2 ):
	bird_friend_sprite.show_behind_parent = false
	cur_dur = new_dir
	match new_dir:
		Vector2.DOWN:
			bird_friend_sprite.position = Vector2( -8, -153 )
			bird_friend_sprite.show_behind_parent = true
			
			player_shape_vert.set_deferred( "disabled", false )
			player_shape_hor.set_deferred( "disabled", true )
		Vector2.UP:
			bird_friend_sprite.position = Vector2( -10, -164 )
			
			player_shape_vert.set_deferred( "disabled", false )
			player_shape_hor.set_deferred( "disabled", true )
		Vector2.LEFT, Vector2.RIGHT:
			bird_friend_sprite.position = Vector2( -50, -145 )
			
			player_shape_vert.set_deferred( "disabled", true )
			player_shape_hor.set_deferred( "disabled", false )
		_:
			pass
