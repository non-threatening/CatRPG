@tool
extends Line2D

var time: float = 0.0
@export var amplitude: float = 3.0
@export var frequency: float = 25.0
@export var points_count: int = 16
@export var point_spacing: float = 28.0
@export var distance_exponential : float = 0.025


func _process(delta):
	time += delta
	var new_points = PackedVector2Array()
	
	if randf() > 0.999:
		time = randf_range( 0.0, 0.666 )
	
	for i in range( points_count ):
		var x = i * ( point_spacing - i )
		var y = sin(( x + time * 100 ) * ( frequency * 0.001 )) * amplitude * ( x * distance_exponential )
		new_points.append( Vector2(x, y) )
			
	points = new_points
