extends StaticBody2D

@onready var sprite_2d: Flower = $Sprite2D


func beam_node() -> void:
	var tween : Tween = create_tween()
	tween.tween_property( sprite_2d.material, "shader_parameter/progress", 3, 10)
	tween.tween_property( sprite_2d, "global_position", Vector2(
		randi_range( 0, 34 * 128 ) - 17 * 128,
		randi_range( 0, 20 * 128 ) - 10 * 128
	), 0 )
	tween.tween_property( sprite_2d.material, "shader_parameter/progress", 0, 10)
