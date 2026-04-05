extends Node2D

@onready var trees: StaticBody2D = $"."
@onready var tree: TreesDream = $TreeSprite
@onready var area_2d: Area2D = $Area2D

var placement : Vector2


func beam_node() -> void:
	var tween : Tween = create_tween()
	tween.tween_property( tree.material, "shader_parameter/progress", 3, 18)
	tween.finished.connect( check_distance )
	
## Don't put them too close together
func check_distance() -> void:
	placement = Vector2(
		randi_range( 0, 34 * 128 ) - 17 * 128,
		randi_range( 0, 20 * 128 ) - 10 * 128 )
	trees.global_position = placement
	
	await get_tree().create_timer( 0.666 ).timeout
	var overlaps_array = area_2d.get_overlapping_areas()
	if overlaps_array.size() > 0:
		check_distance()
	else:
		materialize()


func materialize() -> void:
	var tween2 : Tween = create_tween()
	tween2.tween_property( tree.material, "shader_parameter/progress", 0, 18)
