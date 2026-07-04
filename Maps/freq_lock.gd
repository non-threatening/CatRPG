class_name FreqLock extends Node2D

const TUTORIAL_BUBBLE = preload("uid://50omqkuvm833")
const TUTORIAL_TEXT = preload("uid://bfb5fqf7fpinu")

@export var threshold_time : float = 5
@export var slop : float = 3
@export_enum( "Side", "Up" ) var up_or_side: int = 0

@onready var freq_lock: FreqLock = $"."
@onready var indicator_2d: InteractIndicator = $"../Indicator2D"
@onready var actionable_minigame: Area2D = $"../ActionableMinigame"
@onready var persistent_data_handler: PersistantDataHandler = $PersistantDataHandler
@onready var tone_generator: ToneGenerator = $ToneGenerator
@onready var sprite_2d: Sprite2D = $"../Sprite2D"
@onready var reminder: Node2D = $"../TutorialRightStick/reminder"
@onready var timer: Timer = $"../TutorialRightStick/Timer"
@onready var label_2: Label = $"../TutorialRightStick/Label2"


var frequency : float
var wave_pos : Vector2
var is_opened : bool = false

var tutorial_bubble : Node


func _ready() -> void:
	persistent_data_handler.data_loaded.connect( _is_opened )
	SignalBus.frequency_matched.connect( solved )
	SignalBus.freq_tut_show_stick.connect( _right_stick_reminder )
	SignalBus.freq_hold.connect( _hold )
	_is_opened()
	timer.timeout.connect(_on_timeout)
	reminder.hide()
	reminder.modulate = Color( 1, 1, 1, 0 )

func _hold( _h ) -> void:
	prints("_h", _h )
	label_2.visible = _h


## Check if the this has already been unlocked
func _is_opened() -> void:
	is_opened = persistent_data_handler.value
	if is_opened == true:
		solved()


## Start trigger
func tune_freq() -> void:
	##Check if we've done the tutorial or not
	if StatsManager.knowledge.tutorials.frequency_game_1 == 0:
		prints("tut game 1", StatsManager.knowledge.tutorials.frequency_game_1)
		_start_tutorial( TUTORIAL_BUBBLE, TUTORIAL_TEXT, "freq_tutorial" )
		
	wave_pos = freq_lock.global_position
	## Setup the locked frequency
	frequency = randf_range( 40.0, 110.0 ) ## multiplied by 4 in tone_generator.de
	tone_generator.set_hz( frequency )
	tone_generator.play()
	SignalBus.frequency_match.emit( frequency, wave_pos, threshold_time, slop, up_or_side )
	## Enter the player state freq and start the game
	PlayerManager.player.start_freq()


## Tutorial
func _start_tutorial( bubble, resourse, cue) -> void:
	tutorial_bubble = bubble.instantiate()
	get_tree().current_scene.add_child(tutorial_bubble)
	tutorial_bubble.start( resourse, cue )

func _right_stick_reminder( freq_tut_triggers ) -> void:
	match freq_tut_triggers:
		"auto":
			reminder.show()
			timer.start( 20 )
		_:
			pass

func _on_timeout() -> void:
	var tween : Tween = create_tween()
	tween.set_ease( Tween.EASE_IN )
	tween.tween_property( reminder, "modulate", Color( 1, 1, 1, 1 ), 0.666 )
	await get_tree().create_timer( 6 ).timeout
	prints( "itmer left:", timer.time_left )
	var tween_out : Tween = create_tween()
	tween_out.tween_property( reminder, "modulate", Color( 1, 1, 1, 0 ), 0.666 )



func solved() -> void:
	if is_opened == false:
		persistent_data_handler.set_value()
	##HACK: this is only commented out for testing
	#freq_lock.queue_free()
	#indicator_2d.queue_free()
	#actionable_minigame.queue_free()
	#sprite_2d.frame = 1
	tone_generator.stop()
