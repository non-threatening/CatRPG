extends CanvasLayer

@export var button_focus_audio : AudioStream = preload("res://title_scene/audio/menu_focus.wav")
@export var button_select_audio : AudioStream = preload("res://title_scene/audio/menu_select.wav")

var hearts : Array[ HeartGUI ] = []
var electros : Array[ ElectroGUI ] = []
var spoons : Array[ SpoonsGUI ] = []
var active_save : String = "_1"

@onready var control: Control = $Control
@onready var loading_screen: TextureRect = $LoadingScreen

@onready var time: Control = $Control/HudTime
@onready var time_label: Label = $Control/HudTime/TimeLabel

@onready var hearts_display: HFlowContainer = $Control/Hearts
@onready var electros_display: HFlowContainer = $Control/Electros
@onready var spoons_display: HFlowContainer = $Control/Spoons

@onready var game_over : Control = $Control/GameOver
@onready var continue_button: Button = $Control/GameOver/VBoxContainer/ContinueButton
@onready var title_button: Button = $Control/GameOver/VBoxContainer/TitleButton
@onready var animation_player: AnimationPlayer = $Control/GameOver/AnimationPlayer

@onready var boss_ui: Control = $Control/BossUI
@onready var boss_hp_bar: TextureProgressBar = $Control/BossUI/TextureProgressBar
@onready var boss_label: Label = $Control/BossUI/Label

@onready var notificationUI : NotificationUI = $Control/NotificationControl
@onready var stacked_notificationUI: StackedNotificationUI = $Control/StackedNotificationControl
@onready var center_notificationUI: CenterNotification = $Control/CenterNotification


func _ready() -> void:
	for c in hearts_display.get_children():
		if c is HeartGUI:
			hearts.append( c )
			c.visible = false
			
	for c in electros_display.get_children():
		if c is ElectroGUI:
			electros.append( c )
			c.visible = false
			
	for c in spoons_display.get_children():
		if c is SpoonsGUI:
			spoons.append( c )
			c.visible = false
			
	hide_game_over_screen()
	continue_button.pressed.connect( load_game )
	continue_button.focus_entered.connect( _on_focus_entered )
	title_button.focus_entered.connect( _on_focus_entered )
	title_button.pressed.connect( title_screen )
	LevelManager.level_load_started.connect( hide_game_over_screen )
	LevelManager.level_load_started.connect( show_loading_screen )
	LevelManager.level_loaded.connect( hide_loading_screen )
	
	hide_boss_health()

	PauseMenu.shown.connect( _on_show_menu )
	PauseMenu.hidden.connect( _on_hide_menu )
	ShopMenu.shown.connect( _on_show_menu )
	ShopMenu.hidden.connect( _on_hide_menu )


func _on_focus_entered() -> void:
	AudioManager.play_ui( button_focus_audio )


func show_loading_screen() -> void:
	var tween : Tween = create_tween()
	tween.tween_property( loading_screen, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.15 ).set_ease( Tween.EASE_IN )
	hearts_display.hide()
	electros_display.hide()
	spoons_display.hide()
	time.hide()


func hide_loading_screen() -> void:
	var tween : Tween = create_tween()
	tween.tween_property( loading_screen, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.15 ).set_ease( Tween.EASE_IN )
	hearts_display.show()
	electros_display.show()
	spoons_display.show()
	time.show()


##can queue notifictions from anywhere globaly
func queue_notification( _title : String, _message : String ) -> void:
	notificationUI.add_notification_to_queue( _title, _message )

func queue_stacked_notification( _title : String, _message : String ) -> void:
	stacked_notificationUI.add_notification_to_queue( _title, _message )

func queue_center_notificationUI( _title : String, _message : String ) -> void:
	center_notificationUI.add_notification_to_queue( _title, _message )
	


##	Electro Display
func update_shell( _es: int, _max_es: int ) -> void:
	update_max_es( _max_es )
	for i in _max_es:
		update_bolt( i, _es )

func update_bolt( _index : int, _es : int ) -> void:
	var _value : int = clampi( _es - _index * 2, 0, 2 ) + 7
	electros[ _index ].value = _value

func update_max_es( _max_es : int ) -> void:
	var _es_count : int = roundi( _max_es * 0.5 )
	for i in electros.size():
		if i < _es_count:
			electros[i].visible = true
		else:
			electros[i].visible= false


##	Spoons Display
func update_spoons( _cap: int, _max_cap: int ) -> void:
	update_capacity( _max_cap )
	for i in _max_cap:
		update_spoon( i, _cap )

func update_spoon( _index : int, _cap : int ) -> void:
	var _value : int = clampi( _cap - _index * 2, 0, 2 ) + 10
	spoons[ _index ].value = _value

func update_capacity( _max_cap : int ) -> void:
	var _cap_count : int = roundi( _max_cap * 0.5 )
	for i in spoons.size():
		if i < _cap_count:
			spoons[i].visible = true
		else:
			spoons[i].visible= false


## Heart displays
func update_hp( _hp: int, _max_hp: int ) -> void:
	update_max_hp( _max_hp )
	for i in _max_hp:
		update_heart( i, _hp )
	
func update_heart( _index : int, _hp : int ) -> void:
	var _value : int = clampi( _hp - _index * 2, 0, 2 ) ###!!! +
	hearts[ _index ].value = _value ##Picks the frame
	
func update_max_hp( _max_hp : int ) -> void:
	var _heart_count : int = roundi( _max_hp * 0.5 )
	for i in hearts.size():
		if i < _heart_count:
			hearts[i].visible = true
		else:
			hearts[i].visible= false


func load_game() -> void:
	AudioManager.play_ui( button_select_audio )
	await fade_to_black()
	SaveManager.load_game( active_save )
	pass
	

func title_screen() -> void:
	AudioManager.play_ui( button_select_audio )
	await fade_to_black()
	LevelManager.load_new_level( "res://title_scene/title_scene.tscn", "", Vector2.ZERO )
	

func fade_to_black() -> bool:
	animation_player.play("fade_to_black")
	await animation_player.animation_finished
	PlayerManager.player.revive_player()
	return true


func _on_show_menu() -> void:
	control.hide()


func _on_hide_menu() -> void:
	control.show()


func show_game_over_screen() -> void:
	game_over.show()
	TimeSystem.time_tick.pause()
	game_over.mouse_filter = Control.MOUSE_FILTER_STOP
	
	var can_continue : bool = SaveManager.get_save_file( active_save ) != null
	continue_button.visible = can_continue
	
	animation_player.play("show_game_over")
	
	await animation_player.animation_finished
	if can_continue == true:
		continue_button.grab_focus()
	else:
		title_button.grab_focus()


func hide_game_over_screen() -> void:
	game_over.visible = false
	game_over.mouse_filter = Control.MOUSE_FILTER_IGNORE
	game_over.modulate = Color(1,1,1,0)


func boss_show_health( boss_name : String ) -> void:
	boss_ui.visible = true
	boss_label.text = boss_name
	update_boss_hp( 1, 1 )


func hide_boss_health() -> void:
	boss_ui.visible = false
	
	
func update_boss_hp( hp : int, max_hp : int ) -> void:
	boss_hp_bar.value = clampf( float(hp) / float(max_hp) * 100, 0, 100  )
