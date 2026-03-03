class_name FreqLock extends Area2D

var frequency : float = 66.0
var wave_pos : Vector2
var is_opened : bool = false

@onready var freq_lock: FreqLock = $"."
@onready var indicator_2d: InteractIndicator = $"../Indicator2D"
@onready var actionable_minigame: Area2D = $"../ActionableMinigame"
@onready var wave_form: TextureRect = $WaveForm
@onready var persistant_data_handler: PersistantDataHandler = $PersistantDataHandler
@onready var tone_generator: ToneGenerator = $ToneGenerator


func _ready() -> void:
	freq_lock.hide()
	persistant_data_handler.data_loaded.connect( _is_opened )
	SignalBus.frequecy_matched.connect( solved )
	_is_opened()


func _is_opened() -> void:
	is_opened = persistant_data_handler.value
	if is_opened == true:
		freq_lock.queue_free()
		indicator_2d.queue_free()
		actionable_minigame.queue_free()

## Start trigger
func tune_freq() -> void:
	wave_pos = wave_form.global_position
	freq_lock.show() ###################################################### dlete
	frequency = randf_range( 40.0, 90.0 )
	
	tone_generator.set_hz( frequency )
	tone_generator.play()

	wave_form.material.set_shader_parameter( "wave_frequency", frequency )
	SignalBus.frequency_match.emit( frequency, wave_pos )	
	PlayerManager.player.start_freq()


func solved() -> void:
	persistant_data_handler.set_value()
	freq_lock.queue_free()
	indicator_2d.queue_free()
	actionable_minigame.queue_free()
	pass
