class_name PixquitoeStateChase extends EnemyState

const PATHFINDER : PackedScene = preload("res://Enemies/pathfinder.tscn")

@export var chase_speed : float = 300.0
@export var turn_rate : float = 0.5

@export_category("AI")
@export var vision_area : VisionArea
@export var attack_area : HurtBox
@export var state_aggro_duration : float = 10
@export var next_state : EnemyState

@export var ignore_flee : bool = false

var pathfinder : Pathfinder
var _timer : float = 0.0
var _direction : Vector2
var _can_see_player : bool = false
var rand : float
var nex_x : float
var nex_y : float


func init() -> void:
	if vision_area:
		vision_area.player_entered.connect( _on_player_enter )
		vision_area.player_exited.connect( _on_player_exit )


func enter() -> void:
	##	TODO: Do a flash when we enter chase state, bling!
	pathfinder = PATHFINDER.instantiate() as Pathfinder
	enemy.add_child( pathfinder )
	_timer = state_aggro_duration
	_can_see_player = true
	if attack_area:
		set_deferred( "attack_area.monitoring", true )


func exit() -> void:
	pathfinder.queue_free()
	var get_offset_x : float = round( enemy.global_position.x / 128.0 ) * 128
	var get_offset_y : float = round( enemy.global_position.y / 128.0 ) * 128
	var tween : Tween = create_tween()
	tween.tween_property( enemy, "global_position", Vector2( get_offset_x, get_offset_y ), 0.833 )
	if attack_area:
		attack_area.monitoring = false
	_can_see_player = false


func process( _delta : float ) -> EnemyState:
	if PlayerManager.player.hp <= 0:
		return next_state
	_direction = lerp( _direction, pathfinder.move_dir, turn_rate )
	nex_x = randf_range( 0, 2 ) -1
	nex_y = randf_range( 0, 2 ) -1
	rand = randf()
	if rand <= 0.666:
		enemy.velocity = _direction * chase_speed
	else:
		enemy.velocity = ( ( Vector2( nex_x, nex_y ) ) * chase_speed )
	
	if _can_see_player == false:
		_timer -= _delta
		if _timer < 0:
			return next_state
	else:
		_timer = state_aggro_duration
	return null


func physics( _delta : float ) -> EnemyState:
	return null


func _on_player_enter() -> void:
	_can_see_player = true
	if(
		state_machine.current_state is EnemyStateStun
		or state_machine.current_state is EnemyStateDestroy
		or ignore_flee == true
	):
		return
	state_machine.change_state( self )
	pass


func _on_player_exit() -> void:
	_can_see_player = false # triggers count down in process
	pass
