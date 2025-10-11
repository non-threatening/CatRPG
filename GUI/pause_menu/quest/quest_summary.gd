class_name QuestSummary extends Button


@onready var title_label: RichTextLabel = $VBoxContainer/TitleLabel
@onready var description_label: RichTextLabel = $VBoxContainer/DescriptionLabel

var s : String = "[s]"


func initialize( objective : String, description : String, completed : bool ) -> void:
	if completed == false:
		title_label.text = objective
		description_label.text = description
		title_label.modulate.a = 1.0
		description_label.modulate.a = 1.0
	else:
		title_label.text = s + objective + s
		description_label.text = s + description + s
		title_label.modulate = Color( 0.666, 0.666, 0.666, 0.666 )
		description_label.modulate = Color( 0.666, 0.666, 0.666, 0.666 )
