class_name State_Stun extends State

@export var knockback_speed : float = 300.0
@export var decelerate_speed : float = 10.0
@export var invulnerable_duration : float = 1.0

var hurt_box : HurtBox
var direction : Vector2

var next_state : State = null

@onready var idle : State = $"../Idle"
@onready var death: State_Death = $"../Death"



func init() -> void:
	player.player_damaged.connect( _player_damaged )



func enter() -> void:
	player.animation_player.animation_finished.connect( _animation_finsihed )
	
	direction = player.global_position.direction_to( hurt_box.global_position )
	player.velocity = direction * -knockback_speed
	player.set_direction()
	
	player.update_animation("stun")
	player.make_invulnerable( invulnerable_duration )
	player.effect_animation_player.play( "damaged" )
	
	EffectManager.shake_camera( hurt_box.damage ) # Camera shake based on damage
	pass
	
	

func exit() -> void:
	next_state = null
	player.animation_player.animation_finished.disconnect( _animation_finsihed )
	pass
	
	
## next_state returns null until the animation finishes
func process( _delta : float ) -> State:
	player.velocity -= player.velocity * decelerate_speed * _delta
	return next_state
	
	
func physics( _delta : float ) -> State:
	return null
	
	
func handle_input( _event: InputEvent ) -> State:
	return null


func _player_damaged( _hurt_box : HurtBox ) -> void:
	hurt_box = _hurt_box
	if state_machine.current_state != death:
		state_machine.change_state( self )
	pass
	
	
	
## becomes idle when the animation finishes, and runs the idle state in the process
func _animation_finsihed( _a: String ) -> void:
	next_state = idle
	if player.hp <= 0:
		next_state = death
	pass

	
	
	
	
