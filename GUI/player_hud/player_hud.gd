extends CanvasLayer

@export var button_focus_audio : AudioStream = preload("res://title_scene/audio/menu_focus.wav")
@export var button_select_audio : AudioStream = preload("res://title_scene/audio/menu_select.wav")

var hearts : Array[ HeartGUI ] = []
var electros : Array[ ElectroGUI ] = []

var active_save : String = "_1"

@onready var game_over : Control = $Control/GameOver
@onready var continue_button: Button = $Control/GameOver/VBoxContainer/ContinueButton
@onready var title_button: Button = $Control/GameOver/VBoxContainer/TitleButton
@onready var animation_player: AnimationPlayer = $Control/GameOver/AnimationPlayer
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer
@onready var time_label: Label = $Control/Time/HBoxContainer/TimeLabel
@onready var sprite_moon: Sprite2D = $Control/Time/HBoxContainer/Sprite2D

@onready var control: Control = $Control

@onready var ability_items: HBoxContainer = $Control/Abilities/HBoxContainer
@onready var arrow_count_label: Label = %ArrowCountLabel
@onready var bomb_count_label: Label = %BombCountLabel


@onready var boss_ui: Control = $Control/BossUI
@onready var boss_hp_bar: TextureProgressBar = $Control/BossUI/TextureProgressBar
@onready var boss_label: Label = $Control/BossUI/Label

@onready var notificationUI : NotificationUI = $Control/NotificationControl
@onready var stacked_notificationUI: StackedNotificationUI = $Control/StackedNotificationControl


func _ready() -> void:
	for child in $Control/Hearts.get_children():
		if child is HeartGUI:
			hearts.append( child )
			child.visible = false
			
	for c in $Control/Electros.get_children():
		if c is ElectroGUI:
			electros.append( c )
			c.visible = false
			
	hide_game_over_screen()
	continue_button.focus_entered.connect( play_audio.bind( button_focus_audio ) )
	continue_button.pressed.connect( load_game )
	title_button.focus_entered.connect( play_audio.bind( button_focus_audio ) )
	title_button.pressed.connect( title_screen )
	LevelManager.level_load_started.connect( hide_game_over_screen )
	
	hide_boss_health()
	
	update_ability_ui( 0 )
	
	PauseMenu.shown.connect( _on_show_menu )
	PauseMenu.hidden.connect( _on_hide_menu )
	ShopMenu.shown.connect( _on_show_menu )
	ShopMenu.hidden.connect( _on_hide_menu )
	
	TimeSystem.time_tick.time_unit_changed.connect( time_display )


##	Electro Display
func update_shell( _es: int, _max_es: int ) -> void:
	update_max_es( _max_es )
	for i in _max_es:
		update_bolt( i, _es )


func update_bolt( _index : int, _es : int ) -> void:
	var _value : int = clampi( _es - _index * 2, 0, 2 ) + 7
	electros[ _index ].value = _value
	pass


func update_max_es( _max_es : int ) -> void:
	var _es_count : int = roundi( _max_es * 0.5 )
	for i in electros.size():
		if i < _es_count:
			electros[i].visible = true
		else:
			electros[i].visible= false


## Heart displays
func update_hp( _hp: int, _max_hp: int ) -> void:
	update_max_hp( _max_hp )
	for i in _max_hp:
		update_heart( i, _hp )
	
func update_heart( _index : int, _hp : int ) -> void:
	var _value : int = clampi( _hp - _index * 2, 0, 2 ) ###!!! +
	hearts[ _index ].value = _value ##Picks the frame
	pass
	
func update_max_hp( _max_hp : int ) -> void:
	var _heart_count : int = roundi( _max_hp * 0.5 )
	for i in hearts.size():
		if i < _heart_count:
			hearts[i].visible = true
		else:
			hearts[i].visible= false
	pass	


func load_game() -> void:
	play_audio( button_select_audio )
	await fade_to_black()
	SaveManager.load_game( active_save )
	pass
	

func title_screen() -> void:
	play_audio( button_select_audio )
	await fade_to_black()
	LevelManager.load_new_level( "res://title_scene/title_scene.tscn", "", Vector2.ZERO )
	

func fade_to_black() -> bool:
	animation_player.play("fade_to_black")
	await animation_player.animation_finished
	PlayerManager.player.revive_player()
	return true	
	

func time_display( unit_name: String, new_value: int, old_value: int ) -> void:
	match unit_name:
		"minute":
			var tens = TimeSystem.time_tick.get_time_unit( "minute" ) % 10
			if tens == 0:
				var formatted = TimeSystem.time_tick.get_formatted_time_padded(["hour", "minute"], ":")
				var day = TimeSystem.time_tick.get_time_unit("day")
				var year = TimeSystem.time_tick.get_time_unit("year")
				var show_year : String
				if year != 0:
					show_year = str( "Year ", year ) 
				time_label.text = str( show_year, "  Day %d  %s" % [day, formatted])
		"moon":
			var moon = new_value
			sprite_moon.frame = moon
			print( "moon:", moon )
	pass


func play_audio( _a : AudioStream ) -> void:
	audio.stream = _a
	audio.play()



##can queue notifictions from anywhere globaly
func queue_notification( _title : String, _message : String ) -> void:
	notificationUI.add_notification_to_queue( _title, _message )
	pass

func queue_stacked_notification( _title : String, _message : String ) -> void:
	stacked_notificationUI.add_notification_to_queue( _title, _message )
	pass



func update_ability_items( items : Array[ String ] ) -> void:
	var ability_item : Array[ Node ] = ability_items.get_children()
	for i in ability_item.size():
		if items[ i ] == "":
			ability_item[ i ].hide()
		else:
			ability_item[ i ].show()
	pass



func update_ability_ui( ability_index: int ) -> void:
	var _items : Array[ Node ] = ability_items.get_children()
	for a in _items:
		a.self_modulate = Color( 1,1,1,0 )
		a.modulate = Color( 0.6, 0.6, 0.6, 0.8 )
	_items[ ability_index ].self_modulate = Color( 1,1,1,1 )
	_items[ ability_index ].modulate = Color( 1,1,1,1 )
	play_audio( button_focus_audio )
	pass


func update_arrow_count( count : int ) -> void:
	arrow_count_label.text = str( count )
	pass


func update_bomb_count( count : int ) -> void:
	bomb_count_label.text = str( count )
	pass
	


func _on_show_menu() -> void:
	control.hide()
	pass


func _on_hide_menu() -> void:
	control.show()
	pass

func show_game_over_screen() -> void:
	game_over.visible = true
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
	pass
	
	
func update_boss_hp( hp : int, max_hp : int ) -> void:
	boss_hp_bar.value = clampf( float(hp) / float(max_hp) * 100, 0, 100  )
	pass
