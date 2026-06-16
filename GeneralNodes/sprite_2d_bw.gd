class_name Sprite2DBW extends Sprite2D


func _ready() -> void:
	SignalBus.desaturate.connect( desat )


func desat( _value ) -> void:
	material.set_shader_parameter( "saturation", _value )
