extends StaticBody2D

@export var jump_to_x : float = 40.0
@export var jump_to_y : float = 25.0

@onready var sprite_2d: Sprite2D = $"../Sprite2D"

func walk_on_by() -> void:
	var tween : Tween = create_tween().set_parallel().set_ease( Tween.EASE_IN )
	var tween_2 : Tween = create_tween().set_parallel().set_ease( Tween.EASE_OUT )
	if tween_2.is_running():
		tween_2.stop()
		await get_tree().process_frame
	tween.tween_property( sprite_2d.material, "shader_parameter/x", jump_to_x, 0.2 )
	tween.tween_property( sprite_2d.material, "shader_parameter/y", jump_to_y, 0.2 )
	await tween.finished
	tween_2.tween_property( sprite_2d.material, "shader_parameter/x", sprite_2d.x, 2.66 )
	tween_2.tween_property( sprite_2d.material, "shader_parameter/y", sprite_2d.y, 2.05 )
	tween_2.play()
