extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	focus_entered.connect( _entered_focus )
	focus_exited.connect( _exited_focus )
	pivot_offset_ratio = Vector2( 0.5, 0.5 )


func _entered_focus() -> void:
	scale = Vector2( 1.0, 1.0 )
	var tween : Tween = create_tween()
	tween.tween_property( self, "scale", Vector2( 1.332, 1.332), 0.25 )


func _exited_focus() -> void:
	scale = Vector2( 1.332, 1.332 )
	var tween : Tween = create_tween()
	tween.tween_property( self, "scale", Vector2( 1.0, 1.0), 0.25 )
