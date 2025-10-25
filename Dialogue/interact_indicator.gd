@tool
class_name InteractIndicator extends Area2D

@export var x : int = 0 : set = _set_x
@export var y : int = -0 : set = _set_y

var gate : bool = true

@onready var indicator_2d: InteractIndicator = $"."
@onready var texture_rect: TextureRect = $TextureRect
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	indicator_2d.body_entered.connect( _on_body_entered )
	indicator_2d.body_exited.connect( _on_body_exited )
	texture_rect.position.x = -50 + x
	texture_rect.position.y = -256 + y
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
	#animation_player.play( "bounce" )
	_bounce()
	
	
func _on_body_exited( _a ) -> void:
	#var tween = get_tree().create_tween()
	var tween : Tween = create_tween()
	tween.tween_property(indicator_2d, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.35)
	await get_tree().create_timer( 0.35 ).timeout
	indicator_2d.hide()

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
	var tween : Tween = create_tween()
	tween.tween_property( texture_rect, "position", Vector2( -50 + x, -246 + y ), dur ).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property( texture_rect, "position", Vector2( -50 + x, -256 + y ), dur ).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property( texture_rect, "position", Vector2( -50 + x, -246 + y ), dur ).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property( texture_rect, "position", Vector2( -50 + x, -256 + y ), dur ).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property( texture_rect, "position", Vector2( -50 + x, -251 + y ), dur ).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property( texture_rect, "position", Vector2( -50 + x, -256 + y ), dur ).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property( texture_rect, "position", Vector2( -50 + x, -251 + y ), dur ).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property( texture_rect, "position", Vector2( -50 + x, -256 + y ), dur ).set_ease(Tween.EASE_IN_OUT)
	if gate == true:
		await get_tree().create_timer( 6.66 ).timeout
		_bounce()
	
