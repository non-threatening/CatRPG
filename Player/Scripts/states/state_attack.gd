class_name State_Attack extends State

var attacking : bool = false

@export var attack_sound : AudioStream
@export_range( 1, 20, 0.5 ) var decelerate_speed : float = 5.0

@onready var animation_player : AnimationPlayer = $"../../AnimationPlayer"

@onready var walk : State = $"../Walk"
@onready var idle : State = $"../Idle"
@onready var charge_attack: State = $"../ChargeAttack"
@onready var hurt_box : HurtBox = %AttackHurtBox


func enter() -> void:
	player.paw_swipe()
	player.update_animation("attack")
	animation_player.animation_finished.connect( _end_attack )
	
	var pitch_scale : float = randf_range( 0.9, 1.1 )
	AudioManager.play_effect( attack_sound, pitch_scale )
	
	attacking = true
	
	await get_tree().create_timer( 0.075 ).timeout
	if attacking:
		hurt_box.monitoring = true


func exit() -> void:
	animation_player.animation_finished.disconnect( _end_attack )
	attacking = false
	await get_tree().create_timer( 0.1 ).timeout
	hurt_box.monitoring = false


func process( _delta : float ) -> State:
	player.velocity -= player.velocity * decelerate_speed * _delta
	if attacking == false:
		if player.direction == Vector2.ZERO:
			return idle
		else:
			return walk
	return null


func _end_attack( _newAnimName : String ) -> void:
	if Input.is_action_pressed("attack"):
		state_machine.change_state( charge_attack )
	attacking = false




















	
