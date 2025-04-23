class_name EnemyStateFlee extends EnemyState


@export var anim_name : String = "flee"
@export var flee_speed : float = 800.0
@export var turn_rate : float = 0.5

@export_category( "AI" )
@export var vision_area : VisionArea
@export var attack_area : HurtBox
@export var state_aggro_duration : float = 0.5
@export var next_state : EnemyState

var _timer : float = 0.0
var _direction : Vector2
var _can_see_player : bool = false


func init() -> void:
	if vision_area:
		vision_area.player_entered.connect( _on_player_enter )
		vision_area.player_exited.connect( _on_player_exit )
	pass
	
	

func _enter() -> void:
	_timer = state_aggro_duration
	enemy.update_animation( anim_name )
	if attack_area:
		#attack_area.monitoring = true	
		set_deferred( "attack_area.monitoring", true ) ## or else causes damage on enter ??
	pass
	
	

func _exit() -> void:
	if attack_area:
		attack_area.monitoring = false
	_can_see_player = false
	pass
		
		
## What happens during the _physics_process update in this State?
func process( _delta : float ) -> EnemyState:
	var new_dir : Vector2 = enemy.global_position.direction_to( PlayerManager.player.global_position ).rotated(PI)
	_direction = lerp( _direction, new_dir, turn_rate )
	enemy.velocity = _direction * flee_speed
	if enemy.set_direction( _direction ):
		enemy.update_animation( anim_name )
	
	if _can_see_player == false:
		_timer -= _delta
		if _timer <= 0:
			return next_state
	else:
		_timer = state_aggro_duration * ( randf() + 1 )
	return null
	
## What happens during the _physics_process update in this state?
func physics( _delta : float ) -> EnemyState:
	return null
	
	
func _on_player_enter() -> void:
	_can_see_player = true
	if( 
			state_machine.current_state is EnemyStateStun
			or state_machine.current_state is EnemyStateDestroy
	):
		return
	state_machine.change_state( self )
	pass

func _on_player_exit() -> void:
	_can_see_player = false # triggers count down in process
	pass
	
	
	
	
