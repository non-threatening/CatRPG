class_name PixquitoeStateWander extends EnemyState


@export var anim_name : String = "walk"
@export var wander_speed : float = 50.0

@export_category( "AI" )
@export var state_animation_duration : float = 0.5
@export var state_cycles_min : int = 1
@export var state_cycles_max : int = 3
@export var next_state : EnemyState

var ended : bool = false
#var _timer : float = 0.0
#var _direction : Vector2

## When we initiliaze this state
func init() -> void: 
	pass
	
## Move to specific location

var count : int = 1

## What happens when the player enters this state?
func enter() -> void:
	var current_position : Vector2 = enemy.global_position
	var multiple : Vector2
	var x : float
	var y : float
	var random_dir = pow(-1, randi() % 2)
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
	tween.tween_property( enemy, "global_position", current_position + multiple, 1.666 )
	tween.finished.connect( _change_state )
	pass
	

func _change_state() -> void:
	#print("change stae")
	ended = true
	
	
## What happens when the player exits this state?
func exit() -> void:
	pass
		
		
### What happens during the _physics_process update in this State?
func process( _delta : float ) -> EnemyState:
	if ended == true:
		return next_state
	return null
	
	
## What happens during the _physics_process update in this state?
func physics( _delta : float ) -> EnemyState:
	return null
	
	
