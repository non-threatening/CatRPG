@tool
class_name InteractIndicator extends Area2D

@export var x : int = -32 : set = _set_x
@export var y : int = -128 : set = _set_y

@onready var indicator_2d: InteractIndicator = $"."
@onready var texture_rect: TextureRect = $TextureRect


func _ready() -> void:
	indicator_2d.body_entered.connect( _on_body_entered )
	indicator_2d.body_exited.connect( _on_body_exited )
	texture_rect.position.x = x
	texture_rect.position.y = y
	if Engine.is_editor_hint():
		indicator_2d.show()
		indicator_2d.modulate.a = 0.5
		return
	indicator_2d.modulate.a = 0.0
	indicator_2d.hide()
	
	
func _on_body_entered( _a ) -> void:
	indicator_2d.show()
	var tween = get_tree().create_tween()
	tween.tween_property(indicator_2d, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.35)
	
	
func _on_body_exited( _a ) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(indicator_2d, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.35)
	await get_tree().create_timer( 0.35 ).timeout
	indicator_2d.hide()

func _set_x( _a : = -32 ) -> void:
	x = _a
	if texture_rect:
		texture_rect.position.x = _a


func _set_y( _a : int = -128 ) -> void:
	y = _a
	if texture_rect:
		texture_rect.position.y = _a
