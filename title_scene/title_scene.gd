extends Node2D

const START_LEVEL : String = "res://Maps/Grass_shader_test_map.tscn"

@export var music : AudioStream
@export var button_focus_audio : AudioStream
@export var button_press_audio : AudioStream

@onready var button_new: Button = $CanvasLayer/Control/ColorRect/VBox/ButtonNew
@onready var button_continue: Button = $CanvasLayer/Control/ColorRect/VBox/ButtonContinue
@onready var splash_screen: Control = $CanvasLayer/SplashScreen


func _ready() -> void:
	get_tree().paused = true
	TimeSystem.time_tick.pause()
	PlayerManager.player.hide()
	splash_screen.show()
	PlayerHud.hide()
	PauseMenu.process_mode = Node.PROCESS_MODE_DISABLED
	
	if SaveManager.get_save_file( PlayerHud.active_save ) == null:
		button_continue.disabled = true
		button_continue.visible = false
	
	splash_screen.finished.connect( setup_title_screen )
	LevelManager.level_load_started.connect( exit_title_screen )
	
	
	await get_tree().create_timer( 0.666 ).timeout
	AudioManager.play_music( music )


func setup_title_screen() -> void:
	splash_screen.hide()
	button_new.pressed.connect( start_game )
	button_continue.pressed.connect( load_game )
	button_new.grab_focus()
	button_new.focus_entered.connect( AudioManager.play_ui.bind( button_focus_audio ) )
	button_continue.focus_entered.connect( AudioManager.play_ui.bind( button_focus_audio ) )


func start_game() -> void:
	AudioManager.play_ui( button_press_audio )
	EffectManager.vibrate_controller( 0.666, 0.0, 0.15 )
	LevelManager.load_new_level( START_LEVEL, "LevelTransitionEnter", Vector2.ZERO )


func load_game() -> void:
	AudioManager.play_ui( button_press_audio )
	EffectManager.vibrate_controller( 0.666, 0.0, 0.15 )
	SaveManager.load_game( PlayerHud.active_save )
	
	
func exit_title_screen() -> void:
	PlayerManager.player.visible = true
	PlayerHud.visible = true
	PauseMenu.process_mode = Node.PROCESS_MODE_ALWAYS
	queue_free()
