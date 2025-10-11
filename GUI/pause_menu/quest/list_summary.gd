class_name ListSummary extends Button

var quest : Quest

@onready var title_label: RichTextLabel = $TitleLabel


func initialize( objective : String, completed : bool ) -> void:
	
	var s : String = "[s]"
	
	
	if completed == false:
		title_label.text = objective
		title_label.modulate.a = 1.0
	else:
		title_label.text = s + objective + s
		title_label.modulate = Color( 0.666, 0.666, 0.666, 0.666 )
	pass
