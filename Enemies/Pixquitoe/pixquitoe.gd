class_name Pixquitoe extends Enemy


func initialize() -> void:
	position.x = (randi_range( 1, 32 ) -16 ) * 128
	position.y = (randi_range( 1, 10 ) -5 ) * 128
	
	await get_tree().create_timer( 30 ).timeout
	queue_free()
