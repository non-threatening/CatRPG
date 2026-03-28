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
			var tens = new_value % 10 
			if tens == 0:
				var formatted = TimeSystem.time_tick.get_formatted_time_padded(["hour", "minute"], ":")
				var day = TimeSystem.time_tick.get_time_unit("day")
				var year = TimeSystem.time_tick.get_time_unit("year")
				#var show_year : String
				if year != 0:
					var show_year : String = str( "Year ", year ) 
					time_label.text = str( show_year, "  Day %d  %s" % [day, formatted])
				else:
					time_label.text = str( "Day %d  %s" % [day, formatted])
		"moon":
			var moon = new_value
			var formatted = TimeSystem.time_tick.get_formatted_time_padded(["hour", "minute"], ":")
			var day = TimeSystem.time_tick.get_time_unit("day")
			prints( "moon:", moon, formatted, day )
			sprite_moon.frame = moon
