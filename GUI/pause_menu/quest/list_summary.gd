class_name ListSummary extends MarginContainer

@onready var list_summary: Button = $ListSummary
@onready var rich_text_label: RichTextLabel = $RichTextLabel


func initialize( objective : String, completed : bool ) -> void:
	var s : String = "[s]"
	if completed == false:
		list_summary.text = objective
		rich_text_label.text = objective
		rich_text_label.modulate.a = 1.0
	else:
		list_summary.text = objective
		rich_text_label.bbcode_enabled = true
		rich_text_label.text = s + objective
		rich_text_label.modulate = Color( 0.666, 0.666, 0.666, 0.666 )
	pass
