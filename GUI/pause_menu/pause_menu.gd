extends CanvasLayer

signal shown
signal hidden
signal preview_stats_changed( item : ItemData )

@onready var audio_stream_player: AudioStreamPlayer = $Control/AudioStreamPlayer

@onready var tab_container: TabContainer = $Control/TabContainer

@onready var button_save: Button = $Control/TabContainer/System/VBoxContainer/Button_Save
@onready var button_load: Button = $Control/TabContainer/System/VBoxContainer/Button_Load
@onready var button_quit: Button = $Control/TabContainer/System/VBoxContainer/Button_Quit

@onready var item_description: Label = $Control/TabContainer/Inventory/ItemDescription
@onready var abilities_description: Label = $Control/TabContainer/Inventory/AbilitiesDescription

var is_paused : bool = false
var save_dict : Dictionary

@onready var button_1: Button = $Control/TabContainer/System/Save/Button1
@onready var button_2: Button = $Control/TabContainer/System/Save/Button2
@onready var button_3: Button = $Control/TabContainer/System/Save/Button3
@onready var button_4: Button = $Control/TabContainer/System/Save/Button4
@onready var button_5: Button = $Control/TabContainer/System/Save/Button5
@onready var button_6: Button = $Control/TabContainer/System/Save/Button6

@onready var load_button_1: Button = $Control/TabContainer/System/Load/Button1
@onready var load_button_2: Button = $Control/TabContainer/System/Load/Button2
@onready var load_button_3: Button = $Control/TabContainer/System/Load/Button3
@onready var load_button_4: Button = $Control/TabContainer/System/Load/Button4
@onready var load_button_5: Button = $Control/TabContainer/System/Load/Button5
@onready var load_button_6: Button = $Control/TabContainer/System/Load/Button6

@onready var load_button_1_label: RichTextLabel = $Control/TabContainer/System/Load/Button1/RichTextLabel
@onready var load_button_2_label: RichTextLabel = $Control/TabContainer/System/Load/Button2/RichTextLabel
@onready var load_button_3_label: RichTextLabel = $Control/TabContainer/System/Load/Button3/RichTextLabel
@onready var load_button_4_label: RichTextLabel = $Control/TabContainer/System/Load/Button4/RichTextLabel
@onready var load_button_5_label: RichTextLabel = $Control/TabContainer/System/Load/Button5/RichTextLabel
@onready var load_button_6_label: RichTextLabel = $Control/TabContainer/System/Load/Button6/RichTextLabel

@onready var dialog: ConfirmationDialog = $Control/ConfirmationDialog
@onready var rich_text_label: RichTextLabel = $Control/ConfirmationDialog/RichTextLabel


func _ready() -> void:
	hide_pause_menu()
	button_save.pressed.connect( _on_save_pressed )
	button_load.pressed.connect( _on_load_pressed )
	button_quit.pressed.connect( _on_quit_pressed )
	
	button_1.pressed.connect( _on_save_pressed.bind("_1") )
	button_2.pressed.connect( _on_save_pressed.bind("_2") )
	button_3.pressed.connect( _on_save_pressed.bind("_3") )
	button_4.pressed.connect( _on_save_pressed.bind("_4") )
	button_5.pressed.connect( _on_save_pressed.bind("_5") )
	button_6.pressed.connect( _on_save_pressed.bind("_6") )
	
	load_button_1.pressed.connect( _on_load_pressed.bind("_1") )
	load_button_2.pressed.connect( _on_load_pressed.bind("_2") )
	load_button_3.pressed.connect( _on_load_pressed.bind("_3") )
	load_button_4.pressed.connect( _on_load_pressed.bind("_4") )
	load_button_5.pressed.connect( _on_load_pressed.bind("_5") )
	load_button_6.pressed.connect( _on_load_pressed.bind("_6") )



func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if is_paused == false:
			show_pause_menu()
		else:
			hide_pause_menu()
		get_viewport().set_input_as_handled()
	if is_paused:
		if event.is_action_pressed("right_bumper"):
			change_tab( 1 )
		elif event.is_action_pressed("left_bumper"):
			change_tab( -1 )
		elif event.is_action_pressed("attack"):
			hide_pause_menu()
		
		
func show_pause_menu() -> void:
	get_tree().paused = true
	TimeSystem.time_tick.pause()
	visible = true
	is_paused = true
	tab_container.current_tab = 0
	shown.emit()
	%ArrowCountLabel.text = str( PlayerManager.player.arrow_count )
	%BombCountLabel.text = str( PlayerManager.player.bomb_count )
	
	var file := FileAccess.open( "user://save_files/list_save.sav", FileAccess.READ )
	var json := JSON.new()
	json.parse( file.get_line() )
	save_dict = json.get_data() as Dictionary

	if save_dict.has("_1") and save_dict["_1"] != "":
		load_button_1_label.text = save_dict["_1"]
	else:
		load_button_1_label.text = "empty save"
		button_1.text = "Save"
		load_button_1.set_disabled( true )

	if save_dict.has("_2"):
		load_button_2_label.text = save_dict["_2"]
	else:
		load_button_2_label.text = "empty save"
		button_2.text = "Save"
		load_button_2.set_disabled( true )
		
	if save_dict.has("_3"):
		load_button_3_label.text = save_dict["_3"]
	else:
		load_button_3_label.text = "empty save"
		button_3.text = "Save"
		load_button_3.set_disabled( true )

	if save_dict.has("_4"):
		load_button_4_label.text = save_dict["_4"]
	else:
		load_button_4_label.text = "empty save"
		button_4.text = "Save"
		load_button_4.set_disabled( true )
		
	if save_dict.has("_5"):
		load_button_5_label.text = save_dict["_5"]
	else:
		load_button_5_label.text = "empty save"
		button_5.text = "Save"
		load_button_5.set_disabled( true )
		
	if save_dict.has("_6"):
		load_button_6_label.text = save_dict["_6"]
	else:
		load_button_6_label.text = "empty save"
		button_6.text = "Save"
		load_button_6.set_disabled( true )
	

func hide_pause_menu() -> void:
	get_tree().paused = false
	TimeSystem.time_tick.resume()
	visible = false
	is_paused = false
	hidden.emit()
		
		
func _on_save_pressed( _number ) -> void:
	if is_paused == false:
		return
	var save_text : String = save_dict[_number]
	if save_dict.has( _number ):
		rich_text_label.text = str( "Really overwrite save file:[br]", save_text, "?")
		dialog.confirmed.connect( _on_save_confirmed.bind( _number ) )
		dialog.popup_centered()


func _on_save_confirmed( _number ) -> void:
	SaveManager.save_game( _number )
	PlayerHud.active_save = _number
	match _number:
		"_1":
			load_button_1.set_disabled( false )
			button_1.text = "Save
			Over"
		"_2":
			load_button_2.set_disabled( false )
			button_2.text = "Save
			Over"
		"_3":
			load_button_3.set_disabled( false )
			button_3.text = "Save
			Over"
		"_4":
			load_button_4.set_disabled( false )
			button_4.text = "Save
			Over"
		"_5":
			load_button_5.set_disabled( false )
			button_5.text = "Save
			Over"
		"_6":
			load_button_6.set_disabled( false )
			button_6.text = "Save
			Over"	
	hide_pause_menu()
	pass
	
	
	
func _on_load_pressed( _number ) -> void:
	if is_paused == false:
		return
	var load_text : String = save_dict[_number]
	rich_text_label.text = str( "Loading:[br]", load_text, "[br]will erase current game progress!")
	dialog.confirmed.connect( _on_load_confirmed.bind( _number ) )
	dialog.popup_centered()
		
func _on_load_confirmed( _number ) -> void:
	SaveManager.load_game( _number )
	PlayerHud.active_save = _number
	await LevelManager.level_load_started
	hide_pause_menu()
	pass
	

func _on_quit_pressed() -> void:
	get_tree().quit()


func focused_item_changed( slot : SlotData ) -> void:
	if slot:
		if slot.item_data:
			update_item_description( slot.item_data.description )
			preview_stats( slot.item_data )
	else:
		update_item_description("")
		preview_stats( null )


func update_item_description( new_text : String ) -> void:
	item_description.text = new_text
	
func update_abilities_description( new_text : String ) -> void:
	abilities_description.text = new_text
	
	
func play_audio( audio : AudioStream ) -> void:
	audio_stream_player.stream = audio
	audio_stream_player.play()
	
	
func change_tab( _i : int = 1 ) -> void:
	tab_container.current_tab = wrapi(
		tab_container.current_tab + _i,
		0,
		tab_container.get_tab_count()
		)
	tab_container.get_tab_bar().grab_focus()
	pass


func preview_stats( item : ItemData ) -> void:
	preview_stats_changed.emit( item )


func update_ability_items( items : Array[ String ] ) -> void:
	var item_buttons : Array[ Node ] = %AbilityGridContainer.get_children()
	for i in item_buttons.size():
		if items[ i ] == "":
			item_buttons[ i ].hide()
		else:
			item_buttons[ i ].show()
