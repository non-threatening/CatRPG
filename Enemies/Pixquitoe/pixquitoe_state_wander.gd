class_name PixquitoeStateWander extends EnemyState

@export var next_state : EnemyState
@export var curve : Curve

var count : int = 1
var ended : bool = false
var multiple : Vector2
var x : float
var y : float

@onready var chase_detect: ChaseDetect = $"../../ChaseDetect"
@onready var pixquito: Pixquitoe = $"../.."


func enter() -> void:
	var current_position : Vector2 = enemy.global_position
	var random_dir = pow(-1, randi() % 2) ## returns 1 or -1
	count += 1
	count = count % 2
	if count == 1:
		x = ( random_dir ) * 128
		y = 0
	else:
		x = 0
		y = ( random_dir ) * 128;
	multiple = Vector2( x , y )
	
	var tween : Tween = create_tween()
	tween.tween_property( enemy, "global_position", current_position + multiple, 0.666 ).set_custom_interpolator( tween_curve )
	tween.finished.connect( _change_state )
	
	#	trigger chase state from other enemy
	pixquito.set_collision_layer_value( 10, false )
	chase_detect.set_collision_mask_value( 10, true )
	chase_detect.monitoring = true

func tween_curve( v ):
	if curve != null:
		return curve.sample_baked( v )


func _change_state() -> void:
	ended = true


func process( _delta : float ) -> EnemyState:
	if ended == true:
		return next_state
	return null
