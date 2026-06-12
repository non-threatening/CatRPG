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
@onready var electro_shell_hurt_box: HurtBox = $"../../Collisions/ElectroShellHurtBox"
@onready var sprite_2d: Sprite2D = $"../../Sprite2D"
@onready var gpu_particles_2d: GPUParticles2D = $"../../Sprite2D/footprints/GPUParticles2D"
@onready var gpu_particles_2d_2: GPUParticles2D = $"../../Sprite2D/footprints/GPUParticles2D2"
@onready var color_rect_5: ColorRect = $"../../Sprite2D/ColorRect5"
@onready var color_rect_6: ColorRect = $"../../Sprite2D/ColorRect6"
@onready var color_rect_7: ColorRect = $"../../Sprite2D/ColorRect7"
@onready var foot_smoke_particles_2d: GPUParticles2D = $"../../Sprite2D/FootSmokeParticles2D"


func enter() -> void:
	timer = charge_duration
	disipation_timer = disipation_duration
	is_attacking = false
	walking = false
	electro_shell_hurt_box.damage = 0
	electro_shell_hurt_box.monitoring = true
	color_rect_5.show()
	color_rect_6.show()
	color_rect_7.show()
	color_rect_5.modulate = Color(1, 1, 1, 0)
	color_rect_6.modulate = Color(1, 1, 1, 0)
	color_rect_7.modulate = Color(1, 1, 1, 0)
	#gpu_particles_2d.emitting = true
	#gpu_particles_2d_2.emitting = true
	
	
func exit() -> void:
	electro_shell_hurt_box.set_deferred( "monitoring", false )
	color_rect_5.hide()
	color_rect_6.hide()
	color_rect_7.hide()
	gpu_particles_2d.emitting = false
	gpu_particles_2d_2.emitting = false


func process( _delta : float ) -> State:
	if timer > 0:
		timer -= _delta
		if timer <= 0 and charging == true and player.electro_shell < player.max_electro_shell:
			timer = 0
			charge_complete()
			player.update_electro_shell( 1 )
			AudioManager.play_effect( sfx_charged )
			EffectManager.vibrate_controller( 0.666, 0.0, 0.15)
			
	if disipation_timer > 0:
		disipation_timer -= _delta
		if disipation_timer <= 0:
			if player.electro_shell > 0:
				player.update_electro_shell( -1 )
				disipation_timer = disipation_duration
				if player.electro_shell == 0:
					discharge()


	if is_attacking == false:
		if player.direction == Vector2.ZERO: #not pushing in any direction
			gpu_particles_2d.emitting = false
			gpu_particles_2d_2.emitting = false
			if charging == true:
				if player.electro_shell >= 1:
					player.update_animation( "charge" )
				else:
					player.update_animation( "charging" )
					foot_smoke_particles_2d.emitting = true
			else:
				player.update_animation( "charge" )
			walking = false

		elif player.set_direction() or walking == false: #if the direction has changed
			walking = true
			player.update_animation( "charge_walk" )
			gpu_particles_2d.emitting = true
			gpu_particles_2d_2.emitting = true

	player.velocity = player.direction * move_speed
	return null


func handle_input( _event: InputEvent ) -> State:
	if _event.is_action_released("test") and player.electro_shell <= 0:
		discharge()
	if _event.is_action_released("test") and player.electro_shell >= 1:
		charging = false
		foot_smoke_particles_2d.emitting = false
	if _event.is_action_pressed("test") and charging == false:
		walking = false
		timer = charge_duration
		charging = true
	if _event.is_action_pressed( "attack" ):
		if player.level >= 1:
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


func charge_attack() -> void:
	prints("charge attack:")
	electro_shell_hurt_box.damage = 2
	is_attacking = true
	
	# Electro burst
	player.animation_player.play( "electro_burst" )
	AudioManager.play_effect( sfx_spin )
	
	await get_tree().create_timer(0.1).timeout	
	EffectManager.vibrate_controller( 0.2, 0.666, 0.2 )
	
	await get_tree().create_timer(0.15).timeout
	EffectManager.shake_camera( 1.2 )
	
##TODO: reduce volume of ambient sounds, and tween back up
## then add the birds back one bird at a time with the bird bus
	var _duration : float = player.animation_player.current_animation_length
	player.make_invulnerable( _duration )
	player.update_electro_shell( -1 )
	
	await player.animation_player.animation_finished
	discharge()


func discharge() -> void:
	state_machine.change_state( idle )
	color_rect_5.modulate = Color(1, 1, 1, 0)
	color_rect_6.modulate = Color(1, 1, 1, 0)
	color_rect_7.modulate = Color(1, 1, 1, 0)
	foot_smoke_particles_2d.emitting = false
	await get_tree().process_frame
	charging = true
