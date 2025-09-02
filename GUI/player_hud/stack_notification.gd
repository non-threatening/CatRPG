class_name StackNotification extends MarginContainer

@onready var title_label: Label = $VBoxContainer/StackTitle
@onready var description_label: Label = $VBoxContainer/StackMessage
@onready var stacked_notification: StackNotification = $"."

func initialize( title : String, description : String, counter : int ) -> void:
	title_label.text = title
	description_label.text = description

	await get_tree().create_timer( 5.0 + counter ).timeout
	
	var tween = get_tree().create_tween()
	tween.tween_property(stacked_notification, "modulate", Color.TRANSPARENT, 0.666 )
	
	tween.tween_property(title_label, "theme_override_font_sizes/font_size", 1, 0.444)
	tween.parallel().tween_property(description_label, "theme_override_font_sizes/font_size", 1, 0.444)
	
	await get_tree().create_timer( 1.0 ).timeout
	title_label.hide()
	await get_tree().create_timer( 0.0444 ).timeout
	description_label.hide()
	await get_tree().create_timer( 0.0444 ).timeout
	stacked_notification.queue_free()
