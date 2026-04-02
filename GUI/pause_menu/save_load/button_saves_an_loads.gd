class_name SaveAnLoads extends ButtonHiHat

@onready var label: Label = $Label
@onready var rich_text_label: RichTextLabel = $RichTextLabel


func _ready() -> void:
	super()
	focus_entered.connect( _on_focus )
	focus_exited.connect( _on_exit )


func _on_focus() -> void:
	var tween = create_tween()
	tween.tween_property( label, "modulate", Color( 1, 1, 1, 1 ), 0.25 )


func _on_exit() -> void:
	var tween = create_tween()
	tween.tween_property( label, "modulate", Color( 1, 1, 1, 0 ), 0.15 )
