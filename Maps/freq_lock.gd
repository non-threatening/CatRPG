class_name FreqLock extends Node2D

@export var threshold_time : float = 5
@export var slop : float = 3
@export_enum( "Side", "Up" ) var up_or_side: int = 0

@onready var freq_lock: FreqLock = $"."
@onready var indicator_2d: InteractIndicator = $"../Indicator2D"
@onready var actionable_minigame: Area2D = $"../ActionableMinigame"
@onready var persistant_data_handler: PersistantDataHandler = $PersistantDataHandler
@onready var tone_generator: ToneGenerator = $ToneGenerator
@onready var sprite_2d: Sprite2D = $"../Sprite2D"

var frequency : float
var wave_pos : Vector2
var is_opened : bool = false


func _ready() -> void:
	persistant_data_handler.data_loaded.connect( _is_opened )
	SignalBus.frequecy_matched.connect( solved )
	_is_opened()


## Check if the this has already been unlocked
func _is_opened() -> void:
	is_opened = persistant_data_handler.value
	if is_opened == true:
		solved()


## Start trigger
func tune_freq() -> void:
	wave_pos = freq_lock.global_position
	
	## Setup the locked frequency
	frequency = randf_range( 40.0, 150.0 ) ## multilied by 4 in tone_generator.de
	tone_generator.set_hz( frequency )
	tone_generator.play()
	SignalBus.frequency_match.emit( frequency, wave_pos, threshold_time, slop, up_or_side )
	#prints("Signal match", frequency*4, wave_pos, threshold_time, slop, up_or_side)
	## Enter the player state freq and start the game
	PlayerManager.player.start_freq()


func solved() -> void:
	if is_opened == false:
		persistant_data_handler.set_value()
	#freq_lock.queue_free()
	#indicator_2d.queue_free()
	#actionable_minigame.queue_free()
	#sprite_2d.frame = 1
	tone_generator.stop()
