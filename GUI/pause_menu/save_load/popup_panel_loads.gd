class_name LoadPopup extends PopupPanel

var minutes_passed : float = 1

@onready var button_cancel: Button = $Panel/Load/ButtonCancel
@onready var button_auto: Button = $Panel/Load/ButtonAuto
@onready var load_button_1: Button = $Panel/Load/Button1
@onready var load_button_2: Button = $Panel/Load/Button2
@onready var load_button_3: Button = $Panel/Load/Button3
@onready var load_button_4: Button = $Panel/Load/Button4
@onready var load_button_5: Button = $Panel/Load/Button5

@onready var rich_text_label_2: RichTextLabel = $Panel/Load/ButtonAuto/RichTextLabel2
@onready var auto_text_label: RichTextLabel = $Panel/Load/ButtonAuto/RichTextLabel
@onready var load_button_1_label: RichTextLabel = $Panel/Load/Button1/RichTextLabel
@onready var load_button_2_label: RichTextLabel = $Panel/Load/Button2/RichTextLabel
@onready var load_button_3_label: RichTextLabel = $Panel/Load/Button3/RichTextLabel
@onready var load_button_4_label: RichTextLabel = $Panel/Load/Button4/RichTextLabel
@onready var load_button_5_label: RichTextLabel = $Panel/Load/Button5/RichTextLabel

@onready var button_auto_label: Label = $Panel/Load/ButtonAuto/Label
@onready var button_1_load_label: Label = $Panel/Load/Button1/Label
@onready var button_2_load_label: Label = $Panel/Load/Button2/Label
@onready var button_3_load_label: Label = $Panel/Load/Button3/Label
@onready var button_4_load_label: Label = $Panel/Load/Button4/Label
@onready var button_5_load_label: Label = $Panel/Load/Button5/Label


func _ready() -> void:
	visibility_changed.connect( _on_visible_changed )
	button_cancel.pressed.connect( PauseMenu.hide_pause_menu )
	button_auto.pressed.connect( PauseMenu.on_load_pressed.bind("auto") )
	load_button_1.pressed.connect( PauseMenu.on_load_pressed.bind("_1") )
	load_button_2.pressed.connect( PauseMenu.on_load_pressed.bind("_2") )
	load_button_3.pressed.connect( PauseMenu.on_load_pressed.bind("_3") )
	load_button_4.pressed.connect( PauseMenu.on_load_pressed.bind("_4") )
	load_button_5.pressed.connect( PauseMenu.on_load_pressed.bind("_5") )
	
	
func _on_visible_changed() -> void:
	if visible == true:
		button_cancel.grab_focus()
		minutes_passed = (Time.get_unix_time_from_system() - SaveManager.last_auto_save_time) / 60
		if minutes_passed > 9999:
			minutes_passed = 0

		if PauseMenu.save_dict.has("auto"):
			var get_min = "Auto Save : " + str( round( minutes_passed )) + " minutes ago"
			rich_text_label_2.text = get_min.replace( ".0" , "")
			auto_text_label.text = PauseMenu.save_dict["auto"]
			button_auto_label.show()
			button_auto.set_disabled( false )
		else:
			auto_text_label.text = "empty save"
			button_auto_label.hide()
			button_auto.set_disabled( true )

		if PauseMenu.save_dict.has("_1") and PauseMenu.save_dict["_1"] != "":
			load_button_1_label.text = PauseMenu.save_dict["_1"]
			button_1_load_label.show()
			load_button_1.set_disabled( false )
		else:
			load_button_1_label.text = "empty save"
			button_1_load_label.hide()
			load_button_1.set_disabled( true )

		if PauseMenu.save_dict.has("_2"):
			load_button_2_label.text = PauseMenu.save_dict["_2"]
			button_2_load_label.show()
			load_button_2.set_disabled( false )
		else:
			load_button_2_label.text = "empty save"
			button_2_load_label.hide()
			load_button_2.set_disabled( true )
			
		if PauseMenu.save_dict.has("_3"):
			load_button_3_label.text = PauseMenu.save_dict["_3"]
			button_3_load_label.show()
			load_button_3.set_disabled( false )
		else:
			load_button_3_label.text = "empty save"
			button_3_load_label.hide()
			load_button_3.set_disabled( true )

		if PauseMenu.save_dict.has("_4"):
			load_button_4_label.text = PauseMenu.save_dict["_4"]
			button_4_load_label.show()
			load_button_4.set_disabled( false )
		else:
			load_button_4_label.text = "empty save"
			button_4_load_label.hide()
			load_button_4.set_disabled( true )
			
		if PauseMenu.save_dict.has("_5"):
			load_button_5_label.text = PauseMenu.save_dict["_5"]
			button_5_load_label.show()
			load_button_5.set_disabled( false )
		else:
			load_button_5_label.text = "empty save"
			button_5_load_label.hide()
			load_button_5.set_disabled( true )
