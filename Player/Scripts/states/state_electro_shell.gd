class_name StateElectroShell extends State

@export var charge_duration : float = 3.0
@export var disipation_duration : float = 20.0
@export var move_speed : float =  200.0
@export var sfx_charged : AudioStream
@export var sfx_spin : AudioStream

var timer : float = 0.0
var disipation_timer : float = 20
var walking : bool = false
var is_attacking : bool = false
var particles : ParticleProcessMaterial

var charging : bool = true

@onready var dash: State_Dash = $"../Dash"
@onready var idle: State_Idle = $"../Idle"

#@onready var electro_shell_hurt_box: HurtBox = $"../../Sprite2D/ElectroShellHurtBox"
@onready var electro_shell_hurt_box: HurtBox = $"../../Collisions/ElectroShellHurtBox"

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $"../../Audio/AudioStreamPlayer2D"
@onready var spin_effect_sprite_2d: Sprite2D = $"../../Sprite2D/SpinEffectSprite2D"
@onready var spin_animation_player: AnimationPlayer = $"../../Sprite2D/SpinEffectSprite2D/AnimationPlayer"
#@onready var gpu_particles_2d: GPUParticles2D = $"../../Sprite2D/ElectroShellHurtBox/GPUParticles2D"
@onready var gpu_particles_2d: GPUParticles2D = $"../../Collisions/ChargeAttackHurtBox/GPUParticles2D"

@onready var sprite_2d: Sprite2D = $"../../Sprite2D"




func init() -> void:
	gpu_particles_2d.emitting = false
	particles = gpu_particles_2d.process_material as ParticleProcessMaterial
	spin_effect_sprite_2d.visible = false
	
	## connect to minute time and disipate enery


func enter() -> void:
	timer = charge_duration
	disipation_timer = disipation_duration
	is_attacking = false
	walking = false
	electro_shell_hurt_box.damage = 0
	electro_shell_hurt_box.monitoring = true
	
	## do the shufffle
	
	gpu_particles_2d.emitting = true
	gpu_particles_2d.amount = 15
	gpu_particles_2d.explosiveness = 0
	particles.initial_velocity_min = 10
	particles.initial_velocity_max = 30
	pass
	
	
func exit() -> void:
	electro_shell_hurt_box.set_deferred( "monitoring", false )
	spin_effect_sprite_2d.visible = false
	gpu_particles_2d.emitting = false


func process( _delta : float ) -> State:
	if timer > 0:
		timer -= _delta
		if timer <= 0 and charging == true and player.electro_shell < player.max_electro_shell:
			timer = 0
			charge_complete()
			player.update_electro_shell( 1 )
	
	if disipation_timer > 0:
		disipation_timer -= _delta
		if disipation_timer <= 0:
			if player.electro_shell > 0:
				player.update_electro_shell( -1 )
				disipation_timer = disipation_duration
				if player.electro_shell == 0:
					discharge()
					


	## change to an elif and have a different animation while charging
	if is_attacking == false:
		if player.direction == Vector2.ZERO: #not pushing in any direction
			walking = false
			player.update_animation( "charge" )  ## Needs to be the shuffle.. "charge is outside of this
		elif player.set_direction() or walking == false: #if the direction has changed
			walking = true
			player.update_animation( "charge_walk" )

	player.velocity = player.direction * move_speed
	return null
	


func handle_input( _event: InputEvent ) -> State:
	if _event.is_action_released("test") and player.electro_shell <= 0:
		discharge()
	if _event.is_action_released("test") and player.electro_shell >= 1:
		charging = false 
	if _event.is_action_pressed("test") and charging == false:
		timer = charge_duration
		charging = true
	
	if _event.is_action_pressed( "attack" ):
		if player.level >= 2:
			if is_attacking == false:
				charge_attack()
	elif _event.is_action_pressed( "interact" ):
		PlayerManager.interact()
	elif _event.is_action_pressed( "dash" ): 
		return dash
	return null


func shell_touch() -> void:
	if player.electro_shell > 0:
		player.update_electro_shell( -1 )
		if player.electro_shell <= 0:
			discharge()
	else:
		discharge()

	
func charge_complete() -> void:
	if player.electro_shell <= player.max_electro_shell and charging == true:
		timer = charge_duration
		
	if not electro_shell_hurt_box.did_damage.is_connected( shell_touch ):
		electro_shell_hurt_box.did_damage.connect( shell_touch )
	electro_shell_hurt_box.damage = 1 # Hurts enemy
	
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



func charge_attack() -> void:
	electro_shell_hurt_box.damage = 2
	is_attacking = true
	player.animation_player.play( "charge_attack" )
	player.animation_player.seek( get_spin_frame() )
	play_audio( sfx_spin )
	spin_effect_sprite_2d.visible = true
	spin_animation_player.play( "spin" )
	
	var _duration : float = player.animation_player.current_animation_length
	player.make_invulnerable( _duration )
	
	await get_tree().create_timer( _duration * 0.875 ).timeout
	discharge()


func get_spin_frame() -> float:
	var interval : float = 0.05 # distance between frames
	match player.cardinal_direction:
		Vector2.DOWN:
			return interval * 0 ## always 0, the first frame
		Vector2.UP:
			return interval * 4 ## The fourth frame
		_:
			return interval * 6 ## frame facing right
			
			
func play_audio( _audio : AudioStream ) -> void:
	audio_stream_player_2d.stream = _audio
	audio_stream_player_2d.play()
	pass


func discharge() -> void:
	sprite_2d.material.set_shader_parameter("outline_thickness", 0.0 )
	sprite_2d.material.set_shader_parameter("alpha_threshold", 0.0 )
	charging = true
	state_machine.change_state( idle )

















	
