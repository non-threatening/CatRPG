extends Area2D


func _ready() -> void:
	body_entered.connect( _body_entered )


func _body_entered( _f : Node2D ) -> void:
	## Flowers
	if _f is StaticBody2D:
		_f.walk_on_by()
