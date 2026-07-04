extends StaticBody2D

@onready var flower: Flower = $Flower


func walk_on_by() -> void:
	var tween : Tween = create_tween().set_parallel().set_ease( Tween.EASE_IN )
	var tween_2 : Tween = create_tween().set_parallel().set_ease( Tween.EASE_OUT )
	
	if tween_2.is_running():
		tween_2.stop()
		await get_tree().process_frame
	tween.tween_property( flower.material, "shader_parameter/x", 40, 0.2 )
	tween.tween_property( flower.material, "shader_parameter/y", 25, 0.2 )
	await tween.finished
	tween_2.tween_property( flower.material, "shader_parameter/x", flower.x, 2.66 )
	tween_2.tween_property( flower.material, "shader_parameter/y", flower.y, 2.05 )
	tween_2.play()


func beam_node() -> void:
	var tween : Tween = create_tween()
	tween.tween_property( flower.material, "shader_parameter/progress", 3, 10)
	tween.tween_property( flower, "global_position", Vector2(
		randi_range( 0, 34 * 128 ) - 17 * 128,
		randi_range( 0, 20 * 128 ) - 10 * 128
	), 0 )
	tween.tween_property( flower.material, "shader_parameter/progress", 0, 10)
