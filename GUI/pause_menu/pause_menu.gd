extends CanvasLayer

signal shown
signal hidden
signal preview_stats_changed( item : ItemData )

const KICK__7_ = preload("uid://bgdpmxn86hpae")
const HI_HAT__33_ = preload("uid://bcw1ihsfr3g1j")
const TOM__9_ = preload("uid://b55lwwli8jahd")

var is_paused : bool = false
var save_dict : Dictionary

var current_friend : int

@onready var control: Control = $Control
@onready var tab_container: TabContainer = $Control/TabContainer
@onready var button_quit: Button = $Control/TabContainer/System/Button_Quit
@onready var item_description: Label = $Control/TabContainer/Inventory/ItemDescription
@onready var abilities_description: Label = $Control/TabContainer/Inventory/AbilitiesDescription

@onready var save_button: Button = $Control/TabContainer/System/SaveButton
@onready var load_button: Button = $Control/TabContainer/System/LoadButton
@onready var popup_panel_saves: SavePopup = $Control/PopupPanelSaves
@onready var popup_panel_loads: LoadPopup = $Control/PopupPanelLoads

@onready var dialog: ConfirmationDialog = $Control/ConfirmationDialog
@onready var rich_text_label: RichTextLabel = $Control/ConfirmationDialog/RichTextLabel


func _ready() -> void:
	hide()
	button_quit.pressed.connect( _on_quit_pressed, CONNECT_ONE_SHOT )
	save_button.pressed.connect( _save_dialog_open_pressed )
	load_button.pressed.connect( _load_dialog_open_pressed )
	dialog.canceled.connect( _on_canceled )
	dialog.confirmed.connect( _on_confirmed )
	tab_container.tab_changed.connect( _on_tab_change )


func _on_tab_change( _t ) -> void:
	AudioManager.play_ui( TOM__9_ )


func _on_confirmed() -> void:
	await get_tree().process_frame
	AudioManager.play_ui( HI_HAT__33_ )

func _on_canceled() -> void:
	await get_tree().process_frame
	AudioManager.play_ui( KICK__7_ )


func show_pause_menu() -> void:
	AudioManager.play_ui( HI_HAT__33_ )
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

	
func hide_pause_menu() -> void:
	get_tree().paused = false
	TimeSystem.time_tick.resume()
	is_paused = false
	popup_panel_saves.hide()
	popup_panel_loads.hide()
	hide()
	hidden.emit()


func _on_quit_pressed() -> void:
	rich_text_label.text = str( "Quit for realsies?")
	dialog.confirmed.connect( _quit_game )
	dialog.popup_centered()
	
func _quit_game() -> void:
	get_tree().quit()


func _save_dialog_open_pressed() -> void:
	popup_panel_saves.popup_centered()

func _load_dialog_open_pressed() -> void:
	popup_panel_loads.popup_centered()


func on_save_pressed( _number ) -> void:
	if is_paused == false:
		return
	if save_dict.has( _number ):
		var save_text : String = save_dict[_number] as String
		rich_text_label.text = str( "Really overwrite save file:[br]", save_text, "?")
		dialog.confirmed.connect( _on_save_confirmed.bind( _number ) )
		dialog.popup_centered()
	else:
		_on_save_confirmed( _number )

func _on_save_confirmed( _number ) -> void:
	SaveManager.save_game( _number )
	PlayerHud.active_save = _number
	disconnect_confirm()
	hide_pause_menu()


func on_load_pressed( _number ) -> void:
	if is_paused == false:
		return
	if save_dict.has( _number ):
		var load_text : String = save_dict[_number]
		rich_text_label.text = str( "Loading:[br]", load_text, "[br]will erase current game progress!")
		dialog.confirmed.connect( _on_load_confirmed.bind( _number ) )
		dialog.popup_centered()
	else:
		_on_load_confirmed( _number )

func _on_load_confirmed( _number ) -> void:
	SaveManager.load_game( _number )
	PlayerHud.active_save = _number
	await LevelManager.level_load_started
	disconnect_confirm()
	hide_pause_menu()


func disconnect_confirm() -> void:
	if dialog.confirmed.is_connected( _on_load_confirmed ):
		dialog.confirmed.disconnect( _on_load_confirmed )
	if dialog.confirmed.is_connected( _on_save_confirmed ):
		dialog.confirmed.disconnect( _on_save_confirmed )


##Inventory
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
	


func preview_stats( item : ItemData ) -> void:
	preview_stats_changed.emit( item )



#func update_abilities_description( new_text : String ) -> void:
	#abilities_description.text = new_text
	
func update_ability_items( items : Array ) -> void:
	var item_buttons : Array[ Node ] = %AbilityGridContainer.get_children()
	for i in item_buttons.size():
		if items[ i ] == "":
			item_buttons[ i ].hide()
		else:
			item_buttons[ i ].show()
			current_friend = i


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
			
	
func change_tab( _i : int = 1 ) -> void:
	tab_container.current_tab = wrapi(
		tab_container.current_tab + _i,
		0,
		tab_container.get_tab_count()
		)
	tab_container.get_tab_bar().grab_focus()
