@tool
class_name LevelTransition extends Area2D

enum SIDE { LEFT, RIGHT, TOP, BOTTOM }
const BIRD = preload("res://Player/BirdFriend/bird_friend_flying.tscn")

var bird_instance : BirdFriendFlying = null
var bird_offset : Vector2 = Vector2.ZERO

@export_enum( "In and Out", "Only In", "Only Out" ) var portal_dir : int = 0
@export_file( "*.tscn" ) var level
@export var target_transition_area : String = "LevelTransition"
@export var center_player : bool = false

@export_category( "Collision Area Settings" )
@export_range( 1, 12, 1, "or_greater" ) var size : int = 2:
	set( _v ):
		size = _v
		_update_area()
@export var side: SIDE = SIDE.LEFT :
	set( _v ):
		side = _v
		_update_area()
		
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var level_transition: LevelTransition = $"."



func _ready() -> void:
	_update_area()
	if Engine.is_editor_hint():
		return
	monitoring = false # Set to false if so player doesn't trigger transition area on new level 
	_place_player()
	
	await LevelManager.level_loaded
	if portal_dir == 1: # if only in 
		return
	monitoring = true
	body_entered.connect( _player_entered )


func _player_entered( _p : Node2D ) -> void: ## _p not actually used
	LevelManager.load_new_level( level, target_transition_area, get_offset() )


func _place_player() -> void:
	if name != LevelManager.target_transition: # check if the placement not from level_trans, eg. player_spawn
		return
		
	PlayerManager.set_player_position( global_position + LevelManager.position_offset )

	## If the player throws the bird and then transitons levels, we need the bird to fly back.
	if bird_instance != null:
		return
	if PlayerManager.player.player_friends.selected_friend == 1:
		if PlayerManager.player.bird_friend_sprite.visible == false: ## in throw state
			await get_tree().create_timer( 1.332 ).timeout
			var _b = BIRD.instantiate() as BirdFriendFlying
			var bf_position = PlayerManager.player.bird_friend_sprite.position
			level_transition.add_child( _b ) # needs to be in the scene tree
			_b.toggle_item_magent()
			_b.back_to_cat( bf_position )
			bird_instance = _b


func get_offset() -> Vector2:
	var offset : Vector2 = Vector2.ZERO
	var player_pos = PlayerManager.player.global_position
	
	if side == SIDE.LEFT or side == SIDE.RIGHT:
		if center_player == true:
			offset.y = 0
		else:
			offset.y = player_pos.y - global_position.y
		offset.x = 64
		bird_offset.x = -666
		if side == SIDE.LEFT:
			offset.x *= -1
			bird_offset.x *= -1
		bird_offset.y = offset.y
	else:
		if center_player == true:
			offset.x = 0
		else:
			offset.x = player_pos.x - global_position.x
		offset.y = 64
		bird_offset.y = -666
		if side == SIDE.TOP:
			offset.y *= -1
			bird_offset.y *= -1
		bird_offset.x = offset.x
	return offset


func _update_area() -> void:
	var new_rect : Vector2 = Vector2( 128, 128 )
	var new_position : Vector2 = Vector2.ZERO
	match side:
		SIDE.TOP:
			new_rect.x *= size
			new_position.y -= 64
		SIDE.BOTTOM:
			new_rect.x *= size
			new_position.y += 64
		SIDE.LEFT:
			new_rect.y *= size
			new_position.x -= 64
		SIDE.RIGHT:
			new_rect.y *= size
			new_position.x += 64
		
	if collision_shape == null:
		collision_shape = get_node("CollisionShape2D")
		
	collision_shape.shape.size = new_rect
	collision_shape.position = new_position
