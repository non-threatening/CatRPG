extends Node

signal camera_shook( trauma : float )

const DAMAGE_TEXT = preload("res://00_Globals/global_effects/damage_text.tscn")
const DUST_EFFECT = preload("uid://b3hacak0buk5o")
const HIT_PARTICLES = preload("uid://clnqlpi0hkmrg")



var is_on_steam_deck : bool = Steam.isSteamRunningOnSteamDeck()

func vibrate_controller( _soft : float = 0.666, _hard : float = 0.0, _duration : float = 0.2 ) -> void:
	if is_on_steam_deck == true:
		_soft = 1.0
		_hard = 1.0
	Input.start_joy_vibration( 0, _soft, _hard, _duration )
	
	print( "is steamdeck: ", is_on_steam_deck )


#func is_steam_deck() -> bool:
	#if OS.get_name() == "Linux" or OS.get_name() == "FreeBSD":
		#var screen_size: Vector2i = DisplayServer.screen_get_size()
		#if screen_size == Vector2i(1280, 800) or screen_size == Vector2i(1280, 720):
			#return true
	#return false


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
