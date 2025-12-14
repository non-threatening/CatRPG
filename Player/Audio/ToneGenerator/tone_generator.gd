class_name ToneGenerator extends Node

@export var sample_hz := 22050.0
@export var pulse_hz := 440.0
@export var phase := 0.0

var playback: AudioStreamPlayback
var process_sine: bool = false
var increment : float

@onready var audio: AudioStreamPlayer = $Player


func _ready() -> void:
	audio.stop()
	audio.stream.mix_rate = sample_hz
	audio.volume_db = linear_to_db( 0.5 )


func play() -> void:
	audio.play()
	playback = audio.get_stream_playback()
	process_sine = true


func set_hz( hz ) -> void:
	pulse_hz = hz * 4
	prints( "hz", hz * 4 )


func _fill_buffer() -> void:
	increment = pulse_hz / sample_hz
	
	var to_fill: int = playback.get_frames_available()
	while to_fill > 0:
		playback.push_frame(Vector2.ONE * sin(phase * TAU)) # Audio frames are stereo.
		phase = fmod(phase + increment, 1.0)
		to_fill -= 1


func stop() -> void:
	audio.stop()
	

func _process(_delta: float) -> void:
	if process_sine:
		_fill_buffer()
