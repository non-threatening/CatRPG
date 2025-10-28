extends Node

var time_tick: TimeTick


func _ready() -> void:
	# Create and initialize TimeTick
	time_tick = TimeTick.new()
	time_tick.initialize(1.0)  # Every 0.1 second, a new tick will be triggered.
	
	# Build standard time hierarchy
	# 1 tick = 1 second (virtual second, not real), wraps 0-59
	time_tick.register_time_unit("second", "tick", 1, 60, 0)
	# 60 seconds = 1 minute, wraps 0-59
	time_tick.register_time_unit("minute", "second", 60, 60, 0)
	# 60 minutes = 1 hour, wraps 0-23
	time_tick.register_time_unit("hour", "minute", 60, 24, 0)
	# 24 hours = 1 day, starts at day 1, no wrap
	time_tick.register_time_unit("day", "hour", 24, -1, 1)
	
	time_tick.register_time_unit("moon", "hour", 84, 84, 0)
	
	time_tick.register_time_unit("month", "day", 28, 28, 0)
	
	# Connect to signals
	time_tick.time_unit_changed.connect(_on_time_unit_changed)
	
	## 66.6 is about 10 minutes every 9 seconds
	time_tick.set_time_scale(66.6) 

	## New game
	time_tick.set_time_units({
		"day": 0,
		"hour": 6,
		"minute": 0,
		"moon": 0,
		"month": 0
	})


func _on_time_unit_changed(unit_name: String, new_value: int, old_value: int) -> void:
	match unit_name:
		"day":
			print("\n--- NEW DAY! Day %d → Day %d\n" % [old_value, new_value])
		"moon":
			var moon = time_tick.get_time_unit("moon")
			var phase = ""
			match moon:
				0:
					phase = "Full Moon"
				1:
					phase = "Waxing"
				2:
					phase = "First Quarter"
				3:
					phase = "Waxing"
				4:
					phase = "New Moon"
				5:
					phase = "Waning"
				6:
					phase = "Last Quarter"
				7:
					phase = "Waning"

			print("\n--- Moon Phase: ", phase, " ", moon )


func _exit_tree() -> void:
	if time_tick:
		time_tick.shutdown()
