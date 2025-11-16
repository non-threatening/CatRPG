extends Node

var time_tick: TimeTick
var moon : int = 0
var moon_phase : String = "Full Moon"

var time_gate : bool = false

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
	time_tick.register_time_unit("moon", "hour", 84, 84, 0)
	# 13 months in a year, not really counted/visible 13 * 28 = 364 days
	#time_tick.register_time_unit("month", "day", 28, 28, 1)
	time_tick.register_time_unit( "year", "day", 364, -1, 1 )
	
	# Connect to signals
	time_tick.time_unit_changed.connect(_on_time_unit_changed)
	LevelManager.level_loaded.connect( _on_game_loaded )
	LevelManager.level_load_started.connect( _on_load_started )
	
	##	66.6 is about 10 minutes every 9 seconds; 56 seconds =  1 hour
	##	One day game time is about 21.2 minutes; one day = 1344 seconds
	##	21.2 x 365 = 128 hours = 1 year
	time_tick.set_time_scale(66.6) 

	## New game
	time_tick.set_time_units({
		"day": randi_range( 1, 28 ),
		#"day": 1,
		"hour": randi_range( 17, 23 ),
		#"hour": 8,
		"minute": 0,
		"moon": randi_range( 0, 7 ),
		#"month": 0,
		"year": 0
	})


func _on_load_started() -> void:
	time_gate = false
func _on_game_loaded() -> void:
	time_gate = true


func _on_time_unit_changed(unit_name: String, new_value: int, old_value: int) -> void:
	if time_gate == true:
		match unit_name:
			"day":
				SaveManager.save_game( "auto" )
			"moon":
				moon = new_value
				match moon:
					0:
						moon_phase = "Full Moon"
					1:
						moon_phase = "Waxing"
					2:
						moon_phase = "First Quarter"
					3:
						moon_phase = "Waxing"
					4:
						moon_phase = "New Moon"
					5:
						moon_phase = "Waning"
					6:
						moon_phase = "Last Quarter"
					7:
						moon_phase = "Waning"
			"year":
				print( "YEAR! ", new_value )
			_:
				pass


func _exit_tree() -> void:
	if time_tick:
		time_tick.shutdown()
