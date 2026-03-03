class_name Key extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D


func _ready() -> void:
	_flash()


func _flash() -> void:
	var tween : Tween = create_tween()
	tween.tween_property( sprite_2d.material, "shader_parameter/gd_time", 0.8, 0.666 )
	tween.tween_property( sprite_2d.material, "shader_parameter/gd_time", 0, 0 )
	
	await get_tree().create_timer( 6.66 ).timeout
	_flash()
