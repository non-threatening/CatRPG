class_name PushableReflector extends RigidBody2D

@export var push_speed : float = 200.0
@export var persistent : bool = true
@export var persistent_location : Vector2 = Vector2.ZERO
@export var target_location_size : Vector2 = Vector2( 5, 6 )

var push_direction : Vector2 = Vector2.ZERO : set = _set_push
var on_target : bool = false
var bounce_point : Vector2

@onready var audio : AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var persistant_data_handler: PersistantDataHandler = $PersistantDataHandler
@onready var ray_cast: RayCast2D = $RayCast2D


func _ready() -> void:
	# Set the location if saved
	if persistant_data_handler.value == true:
		position = persistent_location


func _physics_process( _delta: float ) -> void:
	linear_velocity = push_direction * push_speed
	if persistent:
		# If the x corrdinate is on target/close enough
		var x_is_on : bool = abs( position.x - persistent_location.x ) < 15 + target_location_size.x
		var y_is_on : bool = abs( position.y - persistent_location.y ) < 6 + target_location_size.y
		if x_is_on and y_is_on and on_target == false:
			on_target = true
			persistant_data_handler.set_value()
		elif ( x_is_on == false or y_is_on == false ) and on_target == true:
			persistant_data_handler.remove_value()
			on_target = false
	
	if ray_cast.is_colliding():
		if ray_cast.get_collider() is PushableReflector:
			if ray_cast.get_collision_mask_value(5):
				var hit_point : Vector2 = ray_cast.get_collision_point().normalized()
				bounce_point = hit_point.bounce( hit_point )
				#print("------++++++", hit_point )
				#print("------======",  bounce_point)
				
	pass



func _set_push( value : Vector2 ) -> void:
	push_direction = value
	if push_direction == Vector2.ZERO:
		audio.stop()
	else:
		audio.play()
	pass
