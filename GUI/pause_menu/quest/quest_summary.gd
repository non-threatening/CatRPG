class_name QuestSummary extends ButtonHiHat

@onready var title_label: RichTextLabel = $VBoxContainer/TitleLabel
@onready var description_label: RichTextLabel = $VBoxContainer/DescriptionLabel

## The strike through on completed quests/steps
var s : String = "[s]"


func initialize( objective : String, description : String, completed : bool ) -> void:
	text = description ## Invisisble text to expand the button...
	if completed == false:
		title_label.text = objective
		description_label.text = description
		#text = description
		title_label.modulate.a = 1.0
		description_label.modulate.a = 1.0
	else:
		title_label.text = s + objective + s
		description_label.text = s + description + s
		#text = description + s
		title_label.modulate = Color( 0.666, 0.666, 0.666, 0.666 )
		description_label.modulate = Color( 0.666, 0.666, 0.666, 0.666 )
