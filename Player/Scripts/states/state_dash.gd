class_name State_Dash extends State

@export var move_speed : float = 1800.0
@export var effect_delay : float = 0.025
@export var dash_audio : AudioStream

@onready var idle : State = $"../Idle"
@onready var electro_shell: StateElectroShell = $"../ElectroShell"

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
		AudioManager.play_effect( dash_audio )
	effect_timer = 0
	
	
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


func _on_animation_finished( _anim_name : String ) -> void:
	if player.electro_shell >= 1:
		next_state = electro_shell
	else:
		next_state = idle


func spawn_effect() -> void:
	var effect : Node2D = Node2D.new()
	player.get_parent().add_child( effect )
	effect.global_position = player.global_position - Vector2( 0, 0.1 )
	
	var tween : Tween = create_tween()
	tween.set_ease( Tween.EASE_OUT )
	tween.tween_property( effect, "modulate", Color( 1,0,1, 0.1 ), 0.2 )
	tween.chain().tween_callback( effect.queue_free )
	pass
