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
		title_label.modulate.a = 0.666
		 
	#if q_state.is_complete:
		#description_label.text = "Complete"
		#description_label.modulate = Color.FOREST_GREEN
	#else:
		#var step_count : int = q_data.steps.size()
		#var completed_count : int = q_state.completed_steps.size()
		#description_label.text = "Quest2 Step: " + str(completed_count) + "/" + str(step_count)
	pass
