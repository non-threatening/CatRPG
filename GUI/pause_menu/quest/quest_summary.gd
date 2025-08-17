class_name QuestSummary extends Button
	
@onready var title_label: Label = $VBoxContainer/TitleLabel
@onready var description_label: RichTextLabel = $VBoxContainer/DescriptionLabel


func initialize( objective : String, description : String ) -> void:
	title_label.text = objective
	description_label.text = description
