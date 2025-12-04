extends Node2D

@onready var flower: Flower = $Flower


func beam_node() -> void:
	var tween : Tween = create_tween()
	tween.tween_property( flower.material, "shader_parameter/progress", 3, 10)
	tween.tween_property( flower, "global_position", Vector2(
		randi_range( 0, 34 * 128 ) - 17 * 128,
		randi_range( 0, 20 * 128 ) - 10 * 128
	), 0 )
	tween.tween_property( flower.material, "shader_parameter/progress", 0, 10)
