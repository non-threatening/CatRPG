class_name ArelGround extends Node2D

@onready var texture_rect: TextureRect = $TextureRect
@onready var color_rect: ColorRect = $ColorRect
@onready var color_rect_2: ColorRect = $ColorRect2
@onready var color_rect_3: ColorRect = $ColorRect3


func _ready() -> void:
	SignalBus.desaturate.connect( desat )
	

func desat( _value ) -> void:
	texture_rect.material.set_shader_parameter( "saturation", _value )
	color_rect.material.set_shader_parameter( "saturation", _value )
	color_rect_2.material.set_shader_parameter( "saturation", _value )
	color_rect_3.material.set_shader_parameter( "saturation", _value )
	
