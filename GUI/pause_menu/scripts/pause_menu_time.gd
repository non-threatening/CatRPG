class_name PauseMenuTime extends Control

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var moon_label: Label = $MoonLabel
@onready var time_label: Label = $TimeLabel


func _ready() -> void:
	visibility_changed.connect( _show_time )
	

func _show_time() -> void:
	if visible == true:
		sprite_2d.frame = TimeSystem.moon
		moon_label.text = TimeSystem.moon_phase
		time_label.text = TimeSystem.time_display
		pass
