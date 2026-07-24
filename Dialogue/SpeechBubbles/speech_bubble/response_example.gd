extends Button

const TOM__8_ = preload("uid://b4sj6h8vk82d1")

@onready var panel_responses: Panel = $"../../../.."


func _ready() -> void:
	focus_entered.connect( _entered_focus )
	focus_exited.connect( _exited_focus )
	pivot_offset_ratio = Vector2( 0.5, 0.5 )


func _entered_focus() -> void:
	if panel_responses.visible == true:
		AudioManager.play_ui( TOM__8_ )
	scale = Vector2( 1.0, 1.0 )
	var tween : Tween = create_tween()
	tween.tween_property( self, "scale", Vector2( 1.332, 1.332), 0.25 )


func _exited_focus() -> void:
	scale = Vector2( 1.332, 1.332 )
	var tween : Tween = create_tween()
	tween.tween_property( self, "scale", Vector2( 1.0, 1.0), 0.25 )
