class_name GrassTestGround extends Node2D

@onready var texture_rect: TextureRect = $TextureRect
@onready var color_rect: ColorRect = $ColorRect
@onready var texture_rect_2: TextureRect = $TextureRect2
@onready var color_rect_3: ColorRect = $ColorRect3

@export var texture_color : Color = Color.from_hsv(0.047, 0.488, 0.627, 1.0)


func _ready() -> void:
	SignalBus.desaturate.connect( desat )
	

func desat( _value ) -> void:
	texture_rect.material.set_shader_parameter( "saturation", _value )
	color_rect.material.set_shader_parameter( "saturation", _value )
	texture_rect_2.material.set_shader_parameter( "saturation", _value )
	color_rect_3.material.set_shader_parameter( "saturation", _value )

	texture_rect.modulate = Color.from_hsv(0.017, 0.488 * _value, remap( _value, 0, 1, 1.0, 0.627 ), 1.0)
