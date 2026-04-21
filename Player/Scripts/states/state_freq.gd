class_name State_Freq extends State

@export var harmonized_sound : AudioStream

@onready var idle: State_Idle = $"../Idle"
@onready var wave_control: Control = $"../../Sprite2D/WaveControl"
@onready var tone_generator: ToneGenerator = $"../../Audio/ToneGenerator"
@onready var texture_rect: TextureRect = $"../../Sprite2D/WaveControl/TextureRect"
@onready var texture_rect_3: TextureRect = $"../../Sprite2D/WaveControl/TextureRect3"
@onready var glow_behind_rect: TextureRect = $"../../Sprite2D/WaveControl/GlowBehindRect"
@onready var animation: AnimationPlayer = $"../../Sprite2D/WaveControl/AnimationPlayer"


var deg : float
var freq : float
var player_side : bool = true
var position : Vector2
var hold_time : float = 0.0
var action_triggered : bool = false

## params from freq_lock.gd
var threshold_time : float = 4.0  # Time in seconds to hold
var slop : float = 3.0
var up_or_side : int = 0

var flip : int = 0

func _ready() -> void:
	SignalBus.frequency_match.connect( frequency )
	wave_control.hide()
	animation.play("RESET")


func frequency( _freq, _wave_pos, _thresh, _slop, _up_or_side ) -> void:
	freq = _freq
	position = _wave_pos
	threshold_time = _thresh
	slop = _slop
	texture_rect_3.material.set_shader_parameter( "wave_frequency", freq * 0.5 )
	up_or_side = _up_or_side

################# Start #####
func enter() -> void:
	##	Check if player is on the left or right. left = true
	if PlayerManager.player.global_position.x - position.x <= 0:
		player_side = true
		prints("left")
	else:
		player_side = false
		prints("right")
	
	
	# Does the wave point up or to the side. 0 = Side
	match up_or_side:
		0:
			wave_control.position = Vector2( 116, -196 )
			wave_control.rotation_degrees = -50
			texture_rect.size = Vector2( 325, 180 )
			texture_rect_3.size = Vector2( 325, 180 )
			glow_behind_rect.size = Vector2( 400, 160 )
			glow_behind_rect.modulate = Color(1.0, 1.0, 1.0, 0.0)
			player.animation_player.play( "idle_side" )
			if player_side == true:
				PlayerManager.set_player_position( position - Vector2( 337, 51 ) )
				player.sprite.scale.x = 1
			else:
				PlayerManager.set_player_position( position - Vector2( -337, 51 ) )
				player.sprite.scale.x = -1
		1:
			wave_control.position = Vector2( -76, -104 )
			wave_control.rotation_degrees = -90
			texture_rect.size = Vector2( 250, 151)
			texture_rect_3.size = Vector2( 250, 151)
			PlayerManager.set_player_position( position - Vector2( -180, -300 ) )
			player.animation_player.play( "idle_up" )

	wave_control.show()
	tone_generator.play()
	animation.play("unfold")


func harmonized() -> void:
	#audio.stream = harmonized_sound ## The victory bell
	#audio.pitch_scale = randf_range( 0.9, 1.1 )
	#audio.play()
	AudioManager.play_effect( harmonized_sound )	
	wave_control.hide()
	tone_generator.stop()
	tone_generator.process_sine = false
	player.state_machine.change_state( idle )


func handle_input( _event: InputEvent ) -> State:
	if Input.get_vector("right_stick_left", "right_stick_right", "right_stick_up", "right_stick_down"):
		var direction = Input.get_vector("right_stick_left", "right_stick_right", "right_stick_up", "right_stick_down")
		deg = -0.5 * rad_to_deg( direction.angle() * 2) ## max deg 700; min
		prints( "deg", deg )
		if deg > 0:
			texture_rect.material.set_shader_parameter( "wave_frequency", deg * 0.5 )
			tone_generator.set_hz( deg )
	elif _event.is_action_pressed("attack") or _event.is_action_pressed("interact"):
		return idle
	return null


func exit() -> void:
	animation.play("RESET")
	action_triggered = false
	SignalBus.frequecy_matched.emit()
	
	
func process( _delta : float ) -> State:
	if ( freq - slop ) <= deg and deg <= ( freq + slop ):
		hold_time += _delta
		flip = flip + 1
		var flop : int  = flip % 2
		match flop:
			0:
				glow_behind_rect.modulate = Color( 1.0, 1.0, 1.0, (( hold_time * 0.5 ) / threshold_time + 0.3 ))
			_:
				glow_behind_rect.modulate = Color( 1.0, 1.0, 1.0, 0.0 )
				
		if hold_time >= threshold_time and not action_triggered:
			action_triggered = true
			harmonized()
	else:
		hold_time = 0.0
		glow_behind_rect.modulate = Color(1.0, 1.0, 1.0, 0.0)
		action_triggered = false
	return null
