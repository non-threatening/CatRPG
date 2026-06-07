extends Node

signal camera_shook( trauma : float )

const DAMAGE_TEXT = preload("res://00_Globals/global_effects/damage_text.tscn")
const DUST_EFFECT = preload("uid://b3hacak0buk5o")
const HIT_PARTICLES = preload("uid://clnqlpi0hkmrg")


func vibrate_controller( _soft_motor : float = 0.666, _hard_motor : float = 0.0, _duration : float = 0.1 ) -> void:
	Input.start_joy_vibration( 0, _soft_motor, _hard_motor, _duration )
	#prints("controlller type:", ControllerIcons.get_joypad_type() )


func shake_camera( trauma : float = 0.666 ) -> void:
	camera_shook.emit( clampf( trauma, 0, 3) )
	

func damage_text( _damage : int, _pos : Vector2 ) -> void:
	var _t : DamageText = DAMAGE_TEXT.instantiate()
	add_child( _t )
	_t.start( str( _damage ), _pos )


## Create dust effects..
# create new instance of a dust effect
func _create_dust_effect( pos : Vector2 ) -> DustEffect:
	var dust : DustEffect = DUST_EFFECT.instantiate()
	add_child( dust )
	dust.global_position = pos
	return dust

# The dust effects
func landed( pos : Vector2 ) -> void:
	var dust: DustEffect = _create_dust_effect( pos )
	dust.start( DustEffect.TYPE.LANDED )

func land_dust( pos : Vector2 ) -> void:
	var dust: DustEffect = _create_dust_effect( pos )
	dust.start( DustEffect.TYPE.LAND )
	
func poof_dust( pos : Vector2 ) -> void:
	var dust: DustEffect = _create_dust_effect( pos )
	dust.start( DustEffect.TYPE.POOF )


# hit particles
func hit_particles( pos : Vector2, dir : Vector2, settings : HitParticleSettings ) -> void:
	var p : HitParticles = HIT_PARTICLES.instantiate()
	add_child( p )
	p.global_position = pos
	p.start( dir, settings )
