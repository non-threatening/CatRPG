class_name hud_time extends Control

@onready var time_label: Label = $TimeLabel
@onready var sprite_moon: Sprite2D = $Sprite2D

func _ready() -> void:
	TimeSystem.time_tick.time_unit_changed.connect( time_display )
	time_display("minute", 0, 0)
	time_display( "moon", TimeSystem.time_tick.get_time_unit("moon"), 0 )
	

func time_display( unit_name: String, new_value: int, old_value: int ) -> void:
	match unit_name:
		"minute":
			time_label.text = TimeSystem.time_display
		"moon":
			sprite_moon.frame = TimeSystem.moon
