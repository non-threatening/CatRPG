extends Control

signal finished

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var texture_rect: TextureRect = $TextureRect


func _ready() -> void:
	animation_player.animation_finished.connect( _on_animation_finished )
	_flash()

func _flash() -> void:
	await get_tree().create_timer( 1.1666 ).timeout
	var tween : Tween = create_tween()
	tween.tween_property( texture_rect.material, "shader_parameter/gd_time", 1.0, 0.666 )
	tween.tween_property( texture_rect.material, "shader_parameter/gd_time", 0, 0 )

func _on_animation_finished( _p ) -> void:
	finished.emit()
