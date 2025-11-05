extends Control

signal finished

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	#animation_player.animation_finished.connect( _on_animation_finished )
	animation_player.animation_finished.connect( _on_animation_finished )


func _on_animation_finished( _p ) -> void:
	finished.emit()
