class_name collisions extends Node2D

@onready var player : Player = $".."

@onready var interact_shape_horizontal: CollisionShape2D = $InteractX/InteractShapeHorizontal
@onready var interact_shape_vertical: CollisionShape2D = $InteractX/InteractShapeVertical

@onready var push_area: Area2D = $PushArea
@onready var push_area_shape_horizontal: CollisionShape2D = $PushArea/CollisionShapeHorizontal
@onready var push_area_shape_vertical: CollisionShape2D = $PushArea/CollisionShapeVertical

@onready var collision_shape_2dh: CollisionShape2D = $Knockbacks/CollisionShape2DH
@onready var collision_shape_2dv: CollisionShape2D = $Knockbacks/CollisionShape2DV


func _ready() -> void:
	player.DirectionChanged.connect( _update_direction )

# enable/disable collision shapes
func _update_direction( new_direction : Vector2 ) -> void:
	match new_direction:
		Vector2.DOWN, Vector2.UP:
			push_area_shape_vertical.set_deferred( "disabled", false )
			push_area_shape_horizontal.set_deferred( "disabled", true )
			
			interact_shape_vertical.set_deferred( "disabled", false )
			interact_shape_horizontal.set_deferred( "disabled", true )
			
			collision_shape_2dv.set_deferred( "disabled", false )
			collision_shape_2dh.set_deferred( "disabled", true )
		Vector2.LEFT, Vector2.RIGHT:
			push_area_shape_vertical.set_deferred( "disabled", true)
			push_area_shape_horizontal.set_deferred( "disabled", false)
			
			interact_shape_vertical.set_deferred( "disabled", true )
			interact_shape_horizontal.set_deferred( "disabled", false )
			
			collision_shape_2dv.set_deferred( "disabled", true )
			collision_shape_2dh.set_deferred( "disabled", false )
		_:
			pass
	
	if new_direction == Vector2.LEFT:
		push_area.scale.x = -1
	else:
		push_area.scale.x = 1
