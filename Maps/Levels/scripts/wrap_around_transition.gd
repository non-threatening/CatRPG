@tool
class_name WrapAroundTransition extends Area2D

enum SIDE { LEFT, RIGHT, TOP, BOTTOM }

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


func _ready() -> void:
	_update_area()
	if Engine.is_editor_hint():
		return
	body_entered.connect( _player_entered )


func _player_entered( _p : Node2D ) -> void: ## _p not actually used, keep it there.
	var bounds = LevelManager.current_tilemap_bounds
	var offset : Vector2 = get_offset()
	match side:
		SIDE.RIGHT:
			PlayerManager.set_player_position( Vector2( bounds[0].x + offset.x, offset.y ) )
		SIDE.LEFT:
			PlayerManager.set_player_position( Vector2( bounds[1].x + offset.x, offset.y ) )
		SIDE.BOTTOM:
			PlayerManager.set_player_position( Vector2( offset.x, bounds[0].y - offset.y ) )
		SIDE.TOP:
			PlayerManager.set_player_position( Vector2( offset.x, bounds[1].y - offset.y ) )


func get_offset() -> Vector2:
	var offset : Vector2 = Vector2.ZERO
	var player_pos = PlayerManager.player.global_position
	if side == SIDE.LEFT or side == SIDE.RIGHT:
		offset.y = player_pos.y
		offset.x = 128*7
		if side == SIDE.LEFT:
			offset.x *= -1
	else:
		offset.x = player_pos.x
		offset.y = 128*6
		if side == SIDE.BOTTOM:
			offset.y *= -1
	return offset


func _update_area() -> void:
	var new_rect : Vector2 = Vector2( 64, 64 )
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
