@tool
class_name LightPulse extends PointLight2D


func _ready() -> void:
	flicker()
	
	
func flicker() -> void:
	if get_tree():
		energy = randf() * 1.4 + 0.3
		
		#scale = Vector2( 1, 1 ) * energy
		await get_tree().create_timer( 0.1 ).timeout
		flicker()
