class_name ListSummary extends MarginContainer

@onready var list_summary: Button = $ListSummary
@onready var rich_text_label: RichTextLabel = $ListSummary/RichTextLabel


func initialize( objective : String, completed : bool ) -> void:
	var s : String = "[s]"
	list_summary.text = objective
	list_summary.pivot_offset_ratio = Vector2( 0.0, 0.5 )
	if completed == false:
		rich_text_label.text = objective
		rich_text_label.modulate.a = 1.0
	else:
		rich_text_label.text = s + objective
		rich_text_label.modulate = Color( 0.666, 0.666, 0.666, 0.666 )
	pass
