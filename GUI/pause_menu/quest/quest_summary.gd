class_name QuestSummary extends Button
	

@onready var title_label: Label = $TitleLabel
@onready var description_label: Label = $DescriptionLabel


func initialize( objective : String, description : String ) -> void:
	title_label.text = objective
	description_label.text = description
