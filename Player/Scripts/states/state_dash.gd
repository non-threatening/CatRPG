class_name State_Dash extends State

@export var move_speed : float = 1800.0
@export var effect_delay : float = 0.025
@export var dash_audio : AudioStream

@onready var idle : State = $"../Idle"

var direction : Vector2 = Vector2.ZERO
var next_state : State = null
var effect_timer : float = 0


func enter() -> void:
	player.invulnerable = true
	player.update_animation( "dash" )
	player.animation_player.animation_finished.connect( _on_animation_finished )
	direction = player.direction
	if direction == Vector2.ZERO:
		direction = player.cardinal_direction
	if dash_audio:
		player.audio.stream = dash_audio
		player.audio.play()
	effect_timer = 0
	pass
	
	
func exit() -> void:
	player.invulnerable = false
	player.animation_player.animation_finished.disconnect( _on_animation_finished )
	next_state = null #reset
	pass
	
	
func process( _delta : float ) -> State:
	player.velocity = direction * move_speed
	effect_timer -= _delta
	if effect_timer < 0:
		effect_timer = effect_delay
		spawn_effect()
	return next_state ## Returning null means don't change state
	
	
func physics( _delta : float ) -> State:
	return null
	
	
func handle_input( _event: InputEvent ) -> State:
	return null


func _on_animation_finished( _anim_name : String ) -> void:
	next_state = idle
	pass


func spawn_effect() -> void:
	var effect : Node2D = Node2D.new()
	player.get_parent().add_child( effect )
	effect.global_position = player.global_position - Vector2( 0, 0.1 )
	#effect.modulate = Color( 1.5, 0.2, 1.25, 0.75 ) ## Currently no effect

	#await get_tree().process_frame
	#effect.material.set_shader_parameter( "shader_parameter/cover_color", Color( 1.5, 0.2, 1.25, 0.75 ) )
	
	
	var sprite_copy : Sprite2D = player.sprite.duplicate()
	effect.add_child( sprite_copy )
	
	var tween : Tween = create_tween()
	tween.set_ease( Tween.EASE_OUT )
	#tween.tween_property(effect, 'material:shader_parameter/cover_color', Color( 1.5, 0.2, 1.25, 0.75 ), 0.2)
	tween.tween_property( effect, "modulate", Color( 1,0,1, 0.1 ), 0.2 ) ##TODO: No effect because of Material Shader..
	#tween.tween_property( effect, "ShaderParameter/color..." )
	tween.chain().tween_callback( effect.queue_free )
	pass
