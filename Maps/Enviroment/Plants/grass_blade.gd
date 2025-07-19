class_name GrassBlade extends Node2D

@onready var grass_blades: GrassBlade = $"."


func _ready() -> void:
	_set_time_scale()
	_set_random_scale()
	_set_random_color()
	_set_random_xy()
	pass


func _set_time_scale() -> void:
	var set_time = randf_range( 0.9, 1.1)
	grass_blades.material.set_shader_parameter( "time_scale", set_time )
	pass

func _set_random_scale() -> void:
	var _rand = randf_range( 0.15, 0.25 )
	var new_scale = Vector2( _rand, _rand ) 
	grass_blades.scale = new_scale

func _set_random_color() -> void:
	var new_color = Color.from_hsv(
		randf_range( (64.0/360.0), (118.0/360.0) ), 
		randf_range( 0.6, 0.8 ), 
		randf_range( 0.3, 0.4 )
	)
	grass_blades.material.set_shader_parameter( "new_color", new_color )

func _set_random_xy() -> void:
	var x = randi_range( 10, 20 )
	var y = randi_range( 5, 10 )
	grass_blades.material.set_shader_parameter( "x", x )
	grass_blades.material.set_shader_parameter( "y", y )


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
