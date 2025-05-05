class_name State_ChargeAttack extends State

@export var charge_duration : float = 1.0
@export var move_speed : float =  200.0
@export var sfx_charged : AudioStream
@export var sfx_spin : AudioStream

var timer : float = 0.0
var walking : bool = false
var is_attacking : bool = false
var particles : ParticleProcessMaterial

@onready var idle: State_Idle = $"../Idle"
@onready var charge_attack_hurt_box: HurtBox = %ChargeAttackHurtBox
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $"../../Audio/AudioStreamPlayer2D"
@onready var spin_effect_sprite_2d: Sprite2D = $"../../Sprite2D/SpinEffectSprite2D"
@onready var spin_animation_player: AnimationPlayer = $"../../Sprite2D/SpinEffectSprite2D/AnimationPlayer"
@onready var gpu_particles_2d: GPUParticles2D = $"../../Sprite2D/ChargeAttackHurtBox/GPUParticles2D"

@onready var sprite_2d: Sprite2D = $"../../Sprite2D"




func init() -> void:
	gpu_particles_2d.emitting = false
	particles = gpu_particles_2d.process_material as ParticleProcessMaterial
	spin_effect_sprite_2d.visible = false
	pass


## What happens when the player enters this State?
func enter() -> void:
	timer = charge_duration
	is_attacking = false
	walking = false
	charge_attack_hurt_box.damage = 0
	charge_attack_hurt_box.monitoring = true
	gpu_particles_2d.emitting = true
	gpu_particles_2d.amount = 15
	gpu_particles_2d.explosiveness = 0
	particles.initial_velocity_min = 10
	particles.initial_velocity_max = 30
	pass
	
	
## When the player exits
func exit() -> void:
	charge_attack_hurt_box.monitoring = false
	spin_effect_sprite_2d.visible = false
	gpu_particles_2d.emitting = false
	pass
	
	
## What happens during the _process update in the State?	
func process( _delta : float ) -> State:
	if timer > 0:
		timer -= _delta
		if timer <= 0:
			timer = 0
			charge_complete()
	
	if is_attacking == false:
		if player.direction == Vector2.ZERO: #not pushing in any direction
			walking = false
			player.update_animation( "charge" )
		elif player.set_direction() or walking == false: #if the direction has changed
			walking = true
			player.update_animation( "charge_walk" )

	player.velocity = player.direction * move_speed
	return null
	
	
## What happens during the _physics_process update in the State?	
func physics( _delta : float ) -> State:
	return null
	
	

func handle_input( _event: InputEvent ) -> State:
	if _event.is_action_released( "attack" ):
		if timer > 0: # button not held long enough
			return idle
		elif is_attacking == false: ##haven't stated charged attack yet, one ata a time!
			charge_attack()
	return null


func charge_attack() -> void:
	print("charge attack func")
	charge_attack_hurt_box.damage = 2
	is_attacking = true
	player.animation_player.play( "charge_attack" )
	player.animation_player.seek( get_spin_frame() )
	play_audio( sfx_spin )
	spin_effect_sprite_2d.visible = true
	spin_animation_player.play( "spin" )
	
	var _duration : float = player.animation_player.current_animation_length
	player.make_invulnerable( _duration )
	
	await get_tree().create_timer( _duration * 0.875 ).timeout
	sprite_2d.material.set_shader_parameter("outline_thickness", 0.0 )
	sprite_2d.material.set_shader_parameter("alpha_threshold", 0.0 )
	state_machine.change_state( idle )
	pass



func get_spin_frame() -> float:
	var interval : float = 0.05 # distance between frames
	match player.cardinal_direction:
		Vector2.DOWN:
			return interval * 0 ## always 0, the first frame
		Vector2.UP:
			return interval * 4 ## The fourth frame
		_:
			return interval * 6 ## frame facing right

	
	
func charge_complete() -> void:
	play_audio( sfx_charged )
	gpu_particles_2d.amount = 50
	gpu_particles_2d.explosiveness = 1
	particles.initial_velocity_min = 50
	particles.initial_velocity_max = 100
	
	await get_tree().create_timer( 0.5 ).timeout
	gpu_particles_2d.amount = 10
	gpu_particles_2d.explosiveness = 0
	particles.initial_velocity_min = 10
	particles.initial_velocity_max = 30
	pass
	
	
func play_audio( _audio : AudioStream ) -> void:
	audio_stream_player_2d.stream = _audio
	audio_stream_player_2d.play()
	pass

















	
