class_name ListSummary extends Button


@onready var list_summary: ListSummary = $"."


func initialize( objective : String, completed : bool ) -> void:
	var s : String = "[s]"
	if completed == false:
		list_summary.text = objective
		list_summary.modulate.a = 1.0
	else:
		list_summary.text = s + objective + s
		list_summary.modulate = Color( 0.666, 0.666, 0.666, 0.666 )
	pass
