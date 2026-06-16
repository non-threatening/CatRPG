extends Node

var time_tick: TimeTick
var moon : int = 0
var moon_phase : String = "New Moon"
var time_display : String

var day : int = 1
var minute : int = 0
var hour : int = 0
var year : int = 0


func _ready() -> void:
	# Create and initialize TimeTick
	time_tick = TimeTick.new()
	time_tick.initialize(60.0) ## Seconds
	
	# Build standard time hierarchy
	# 1 tick = 1 second (virtual second, not real), wraps 0-59
	#time_tick.register_time_unit("second", "tick", 1, 60, 0)
	# 60 seconds = 1 minute, wraps 0-59
	time_tick.register_time_unit("minute", "tick", 1, 60, 0)
	# 60 minutes = 1 hour, wraps 0-23
	time_tick.register_time_unit("hour", "minute", 60, 24, 0)
	# 24 hours = 1 day, starts at day 1, no wrap
	time_tick.register_time_unit("day", "hour", 24, 364, 1)
	# 1 moon phase 3.5 days, 8 phases in a 28 day month
	time_tick.register_time_unit("moon", "hour", 84, 8, 0)
	# 13 months in a year, not really counted/visible 13 * 28 = 364 days
	time_tick.register_time_unit( "year", "day", 364, -1, 1 )
	
	# Connect to signals
	time_tick.time_unit_changed.connect(_on_time_unit_changed)

	
	##	66.6 is about 10 minutes every 9 seconds; 56 seconds =  1 hour
	##	One day game time is about 21.2 minutes; one day = 1344 seconds
	##	21.2 x 365 = 128 hours = 1 year
	#time_tick.set_time_scale(66.6) 
	time_tick.set_time_scale(6666.6) 

	## New game
	time_tick.set_time_units({
		"day": 1,
		"hour": 8,
		"minute": 0,
		"moon": 0,
		"year": 0
	})


func _on_time_unit_changed(unit_name: String, new_value: int, old_value: int) -> void:
	if LevelManager.level_loaded:
		match unit_name:
			"minute":
				var tens = new_value % 10 
				if tens == 0:
					var formatted = TimeSystem.time_tick.get_formatted_time_padded(["hour", "minute"], ":")
					minute = TimeSystem.time_tick.get_time_unit("minute")
					hour = TimeSystem.time_tick.get_time_unit("hour")
					day = TimeSystem.time_tick.get_time_unit("day")
					year = TimeSystem.time_tick.get_time_unit("year")
					if year != 0:
						var show_year : String = str( "Year ", year ) 
						time_display = str( show_year, "  Day %d  %s" % [day, formatted])
					else:
						time_display = str( "Day %d  %s" % [day, formatted])
			"moon":
				moon = new_value
				match moon:
					0:
						moon_phase = "New Moon"
					1:
						moon_phase = "Waxing Crescent"
					2:
						moon_phase = "First Quarter"
					3:
						moon_phase = "Waxing Gibbous"
					4:
						moon_phase = "Full Moon"
					5:
						moon_phase = "Waning Gibbous"
					6:
						moon_phase = "Last Quarter"
					7:
						moon_phase = "Waning Crescent"
			"year":
				print( "YEAR! ", new_value )
			_:
				pass


func _exit_tree() -> void:
	if time_tick:
		time_tick.shutdown()
