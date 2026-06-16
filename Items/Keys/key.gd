class_name Key extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var timer: Timer = $Timer


func _ready() -> void:
	SignalBus.desaturate.connect( desat )
	timer.timeout.connect( _flash )


func desat( _value ) -> void:
	sprite_2d.material.set_shader_parameter( "saturation", _value )


func _flash() -> void:
	var tween : Tween = create_tween()
	tween.tween_property( sprite_2d.material, "shader_parameter/gd_time", 0.8, 0.666 )
	tween.tween_property( sprite_2d.material, "shader_parameter/gd_time", 0, 0 )
