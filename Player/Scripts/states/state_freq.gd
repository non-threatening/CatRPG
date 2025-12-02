class_name State_Freq extends State

@export var harmonized_sound : AudioStream

@onready var idle: State_Idle = $"../Idle"
@onready var audio: AudioStreamPlayer2D = $"../../Audio/AudioStreamPlayer2D"
@onready var control: Control = $"../../Sprite2D/Control"

var deg : float
var freq : float
var position : Vector2
var hold_time: float = 0.0
var threshold_time: float = 3.0  # Time in seconds to hold
var action_triggered: bool = false


func _ready() -> void:
	SignalBus.frequency_match.connect( frequency )
	control.hide()

func frequency( _freq, _wave_pos ) -> void:
	freq = _freq
	position = _wave_pos
	print( "state freq: ", _freq, " pos: ", _wave_pos )
	

func enter() -> void:
	control.show()
	player.update_animation( "walk" )
	## move to location, in the process.. or _physics
	PlayerManager.set_player_position( position - Vector2( 74, -104 ) )

	player.sprite.scale.x = 1
	player.animation_player.play( "idle_side" )


func harmonized() -> void:
	audio.stream = harmonized_sound
	audio.pitch_scale = randf_range( 0.9, 1.1 )
	audio.play()
	control.hide()
	player.state_machine.change_state( idle )



func handle_input( _event: InputEvent ) -> State:
	if Input.get_vector("right_stick_left", "right_stick_right", "right_stick_up", "right_stick_down"):
		var direction = Input.get_vector("right_stick_left", "right_stick_right", "right_stick_up", "right_stick_down")
		deg = -0.5 * rad_to_deg( direction.angle() ) + 10
		if deg > 0: 
			$"../../Sprite2D/Control/TextureRect".material.set_shader_parameter( "wave_frequency", deg )
			print( deg, " ", freq )
			
	elif _event.is_action_pressed("attack"):
		return idle
	elif _event.is_action_pressed("interact"):
		return idle
	return null


## When the player exits
func exit() -> void:
	action_triggered = false
	SignalBus.frequecy_matched.emit()
	
	
## What happens during the _process update in the State?	
func process( _delta : float ) -> State:
	if ( freq - 3 ) <= deg and deg <= ( freq + 3 ):
		hold_time += _delta
		if hold_time >= threshold_time and not action_triggered:
			action_triggered = true
			harmonized()
	else:
		hold_time = 0.0
		action_triggered = false
	return null
	
	
## What happens during the _physics_process update in the State?	
func physics( _delta : float ) -> State:
	return null
	
	
