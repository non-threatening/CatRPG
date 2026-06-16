extends Polygon2D

var hour : int = 0
var minute : int = 0
var minutes : int = 0
var degree : int = 360
var thing : int = 0
var tens : int = 0
var darkness : float = 0.0

@onready var canvas_modulate: CanvasModulate = $"../CanvasModulate"


func _ready() -> void:
	TimeSystem.time_tick.time_unit_changed.connect( _on_time_unit_changed )
	hour = TimeSystem.time_tick.get_time_unit( "hour" )
	minute = TimeSystem.time_tick.get_time_unit( "minute" )
	_on_time_unit_changed( "minute", minute, 0 )


func _on_time_unit_changed(unit_name: String, new_value: int, old_value: int) -> void:
	match unit_name:
		"hour":
			hour = new_value
		"minute":
			minute = new_value
			tens = minute % 10
			night_time()
			if tens == 0:
				minutes = hour * 60 + minute
				thing = int( remap( minutes, 1, 1440, 0, 360 ) )
				material.set_shader_parameter( "angle", thing )
				## 0 - 360 -- 15 is a hour
				var dist : float = minutes % 720
				var dist2 : float = 0
				if dist < 360:
					dist2 = remap( dist, 0, 360, 20, 100  )
				else:
					dist2 = remap( dist, 360, 720, 100, 20  ) 
				material.set_shader_parameter( "max_dist", dist2 )


func night_time() -> void:
	minutes = hour * 60 + minute
	darkness = fmod( remap( minutes, 1.0, 1440.0, 0.0, 360.0 ), 360 )
	# Still night time
	if darkness >= 0 and darkness < 120:
		if darkness <= 69:
			SignalBus.desaturate.emit( 0.0 )
		# Getting light out
		elif darkness > 70:
			SignalBus.desaturate.emit( (((darkness - 90) * -0.01) * 2 - 1.0) * -1.0 - 0.60041695621959 )
	# All day
	elif darkness >= 121 and darkness <= 269:
		SignalBus.desaturate.emit( 1.0 )
	# Night
	elif darkness > 270 and darkness < 360:
		if darkness >= 313:
			SignalBus.desaturate.emit( 0.0 )
	# Getting dark
		elif darkness < 312:
			SignalBus.desaturate.emit( remap(  ((darkness - 270) * 0.02 -1.0) * -1.0, 0.16, 1, 0.0, 1 ))
