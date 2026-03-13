@tool
class_name InteractIndicator extends Area2D

@export var x : int = -50 : set = _set_x
@export var y : int = -250 : set = _set_y

var bounce_gate : bool = true

@onready var indicator_2d: InteractIndicator = $"."
@onready var texture_rect: TextureRect = $TextureRect


func _ready() -> void:
	body_entered.connect( _on_body_entered )
	body_exited.connect( _on_body_exited )
	texture_rect.position.x = x
	texture_rect.position.y = y
	if Engine.is_editor_hint():
		show()
		modulate.a = 0.5
		return
	modulate.a = 0.0
	hide()
	
	
func _on_body_entered( _a ) -> void:
	show()
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.35)
	bounce_gate = true
	_bounce()
	
	
func _on_body_exited( _a ) -> void:
	var tween : Tween = create_tween()
	tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.35)
	await get_tree().create_timer( 0.35 ).timeout
	hide()
	bounce_gate = false


func _set_x( _a : = 0 ) -> void:
	x = _a
	if texture_rect:
		texture_rect.position.x = _a


func _set_y( _a : int = 0 ) -> void:
	y = _a
	if texture_rect:
		texture_rect.position.y = _a


func _bounce() -> void:
	var dur : float = 0.033
	await get_tree().create_timer( 0.35 ).timeout
	var tween : Tween = create_tween()
	tween.tween_property( texture_rect, "position", Vector2( x, -10 + y ), dur ).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property( texture_rect, "position", Vector2( x, y ), dur ).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property( texture_rect, "position", Vector2( x, -10 + y ), dur ).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property( texture_rect, "position", Vector2( x, y ), dur ).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property( texture_rect, "position", Vector2( x, -5 + y ), dur ).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property( texture_rect, "position", Vector2( x, y ), dur ).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property( texture_rect, "position", Vector2( x, -5 + y ), dur ).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property( texture_rect, "position", Vector2( x, + y ), dur ).set_ease(Tween.EASE_IN_OUT)
	await get_tree().create_timer( 6.66 ).timeout
	if bounce_gate == true:
		_bounce()
	
