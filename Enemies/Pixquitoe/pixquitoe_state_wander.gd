class_name PixquitoeStateWander extends EnemyState

@export var next_state : EnemyState

var count : int = 1
var ended : bool = false


func enter() -> void:
	var current_position : Vector2 = enemy.global_position
	var multiple : Vector2
	var x : float
	var y : float
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
	tween.tween_property( enemy, "global_position", current_position + multiple, 0.666 )
	tween.finished.connect( _change_state )
	pass
	

func _change_state() -> void:
	ended = true


func process( _delta : float ) -> EnemyState:
	if ended == true:
		return next_state
	return null
