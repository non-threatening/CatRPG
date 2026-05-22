class_name SwipeSlash extends Node2D

@onready var slash_highlight: ColorRect = $SlashHighlight
@onready var slash_counter_glitter: ColorRect = $SlashCounterGlitter


func _ready() -> void:
	slash_highlight.material.set_shader_parameter("progress", 0.01 )
	slash_counter_glitter.material.set_shader_parameter("progress", 0.01 )


func swipe() -> void:
	var tween : Tween = create_tween()
	tween.set_parallel()
	tween.tween_property( slash_highlight.material, "shader_parameter/progress", 0.5, 0.2 )
	tween.tween_property( slash_counter_glitter.material, "shader_parameter/progress", 0.8, 0.3 )

	await tween.finished
	slash_highlight.material.set_shader_parameter("progress", 0.01 )
	slash_counter_glitter.material.set_shader_parameter("progress", 0.01 )
