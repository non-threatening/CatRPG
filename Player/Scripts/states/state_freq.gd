class_name State_Freq extends State

@export var harmonized_sound : AudioStream

@onready var idle: State_Idle = $"../Idle"
@onready var audio: AudioStreamPlayer2D = $"../../Audio/AudioStreamPlayer2D"
@onready var control: Control = $"../../Sprite2D/WaveControl"
@onready var tone_generator: ToneGenerator = $"../../Audio/ToneGenerator"

var deg : float
var freq : float
var position : Vector2
var hold_time : float = 0.0
var threshold_time : float = 3.0  # Time in seconds to hold
var action_triggered : bool = false


func _ready() -> void:
	SignalBus.frequency_match.connect( frequency )
	control.hide()


func frequency( _freq, _wave_pos ) -> void:
	freq = _freq
	position = _wave_pos
	

func enter() -> void:
	control.show()
	player.update_animation( "walk" )
	## move to location, in the process.. or _physics
	PlayerManager.set_player_position( position - Vector2( 74, -104 ) )

	player.sprite.scale.x = 1
	player.animation_player.play( "idle_side" )
	
	tone_generator.play()


func harmonized() -> void:
	audio.stream = harmonized_sound
	audio.pitch_scale = randf_range( 0.9, 1.1 )
	audio.play()
	control.hide()
	tone_generator.stop()
	tone_generator.process_sine = false
	player.state_machine.change_state( idle )


func handle_input( _event: InputEvent ) -> State:
	if Input.get_vector("right_stick_left", "right_stick_right", "right_stick_up", "right_stick_down"):
		var direction = Input.get_vector("right_stick_left", "right_stick_right", "right_stick_up", "right_stick_down")
		deg = -0.5 * rad_to_deg( direction.angle() ) + 10
		if deg > 0:
			$"../../Sprite2D/WaveControl/TextureRect".material.set_shader_parameter( "wave_frequency", deg )
			
			tone_generator.set_hz( deg )
			prints( "input", deg, freq )
			
	elif _event.is_action_pressed("attack") or _event.is_action_pressed("interact"):
		return idle
	return null


func exit() -> void:
	action_triggered = false
	SignalBus.frequecy_matched.emit()
	
	
func process( _delta : float ) -> State:
	if ( freq - 3 ) <= deg and deg <= ( freq + 3 ):
		hold_time += _delta
		
		##TODO: Put an effect here... pulsing; light and volume
		
		if hold_time >= threshold_time and not action_triggered:
			action_triggered = true
			harmonized()
	else:
		hold_time = 0.0
		action_triggered = false
	return null
