class_name EnemyStateSkitter extends EnemyState


@export var anim_name : String = "skitter"
@export var wander_speed : float = 500.0

@export_category( "AI" )
@export var state_animation_duration : float = 0.1
@export var state_cycles_min : int = 1
@export var state_cycles_max : int = 2
@export var next_state : EnemyState

var _timer : float = 0.0
var _jitter : float = 0.0
var _direction : Vector2

## When we initiliaze this state
func init() -> void: 
	pass
	
	
## What happens when the player enters this state?
func enter() -> void:
	_timer = randi_range( state_cycles_min, state_cycles_max ) * state_animation_duration
	_jitter = _timer * 0.2
	var rand = randi_range( 0, 3 )
	var count : int = 0
	if count % 4 == 0:
		count += count + 1
		print(count)
		_direction = enemy.DIR_4[ rand ]
	enemy.velocity = _direction * wander_speed
	enemy.set_direction( _direction )
	enemy.update_animation( anim_name )
	pass
	
	
## What happens when the player exits this state?
func exit() -> void:
	pass
		
		
## What happens during the _physics_process update in this State?
func process( _delta : float ) -> EnemyState:
	_timer -= _delta
	if _timer <= 0:
		return next_state
	else:
		await get_tree().create_timer( _jitter * randf() )
		#enter()
	return null
	
#func flip_state() -> void:
	#if anim_name == "skitter":
		#anim_name = "idle"
	#else:
		#anim_name = "skitter"
	
	
## What happens during the _physics_process update in this state?
func physics( _delta : float ) -> EnemyState:
	return null
	
	
