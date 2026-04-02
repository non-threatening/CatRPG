class_name SavePopup extends PopupPanel

@onready var button_cancel: Button = $Panel/Save/ButtonCancel
@onready var button_1: Button = $Panel/Save/Button1
@onready var button_2: Button = $Panel/Save/Button2
@onready var button_3: Button = $Panel/Save/Button3
@onready var button_4: Button = $Panel/Save/Button4
@onready var button_5: Button = $Panel/Save/Button5

@onready var rich_text_label_1: RichTextLabel = $Panel/Save/Button1/RichTextLabel
@onready var rich_text_label_2: RichTextLabel = $Panel/Save/Button2/RichTextLabel
@onready var rich_text_label_3: RichTextLabel = $Panel/Save/Button3/RichTextLabel
@onready var rich_text_label_4: RichTextLabel = $Panel/Save/Button4/RichTextLabel
@onready var rich_text_label_5: RichTextLabel = $Panel/Save/Button5/RichTextLabel

@onready var label_1: RichTextLabel = $Panel/Save/Button1/RichTextLabel
@onready var label_2: RichTextLabel = $Panel/Save/Button2/RichTextLabel
@onready var label_3: RichTextLabel = $Panel/Save/Button3/RichTextLabel
@onready var label_4: RichTextLabel = $Panel/Save/Button4/RichTextLabel
@onready var label_5: RichTextLabel = $Panel/Save/Button5/RichTextLabel

func _ready() -> void:
	visibility_changed.connect( _on_visible_changed )
	button_cancel.pressed.connect( PauseMenu.hide_pause_menu )
	button_1.pressed.connect( PauseMenu.on_save_pressed.bind("_1") )
	button_2.pressed.connect( PauseMenu.on_save_pressed.bind("_2") )
	button_3.pressed.connect( PauseMenu.on_save_pressed.bind("_3") )
	button_4.pressed.connect( PauseMenu.on_save_pressed.bind("_4") )
	button_5.pressed.connect( PauseMenu.on_save_pressed.bind("_5") )


func _on_visible_changed() -> void:
	if visible == true:
		button_cancel.grab_focus()
		
		if PauseMenu.save_dict.has("_1") and PauseMenu.save_dict["_1"] != "":
			rich_text_label_1.text = PauseMenu.save_dict["_1"]
		else:
			rich_text_label_1.text = "Save one empty"

		if PauseMenu.save_dict.has("_2"):
			rich_text_label_2.text = PauseMenu.save_dict["_2"]
		else:
			rich_text_label_2.text = "Save two empty"

		if PauseMenu.save_dict.has("_3"):
			rich_text_label_3.text = PauseMenu.save_dict["_3"]
		else:
			rich_text_label_3.text = "Save three empty"

		if PauseMenu.save_dict.has("_4"):
			rich_text_label_4.text = PauseMenu.save_dict["_4"]
		else:
			rich_text_label_4.text = "Save four empty"

		if PauseMenu.save_dict.has("_5"):
			rich_text_label_5.text = PauseMenu.save_dict["_5"]
		else:
			rich_text_label_5.text = "Save five empty"
