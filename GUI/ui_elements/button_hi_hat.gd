class_name ButtonHiHat extends Button

const HI_HAT__10_ = preload("uid://u7bfr1mauqbt")
const KICK__7_ = preload("uid://bgdpmxn86hpae")
const TOM__9_ = preload("uid://b55lwwli8jahd")

@export var focus_sound : AudioStream = HI_HAT__10_
@export var focus_accent_delay : float = 0.0
@export var focus_accent_sound : AudioStream = TOM__9_

@export var pressed_sound : AudioStream = KICK__7_
@export var pressed_sound_delay : float = 0.0
@export var pressed_accent_sound : AudioStream = HI_HAT__10_


func _ready() -> void:
	focus_entered.connect( on_focus_entered )
	focus_exited.connect( on_focus_exited )
	button_up.connect( on_button_up )
	pivot_offset_ratio = Vector2( 0.5, 0.5 )


func on_focus_entered() -> void:
	var tween_entered = create_tween()
	tween_entered.tween_property( self, "scale", Vector2( 1.125, 1.125 ), 0.2 )
	if focus_sound:
		AudioManager.play_ui( focus_sound )
	if focus_accent_sound:
		await get_tree().create_timer( focus_accent_delay ).timeout
		AudioManager.play_ui( focus_accent_sound )


func on_focus_exited() -> void:
	var tween_exited = create_tween()
	tween_exited.tween_property( self, "scale", Vector2( 1.0, 1.0 ), 0.2 )


func on_button_up() -> void:
	await get_tree().process_frame
	if pressed_sound:
		AudioManager.play_ui( pressed_sound )
	if pressed_accent_sound:
		await get_tree().create_timer( pressed_sound_delay ).timeout
		AudioManager.play_ui( pressed_accent_sound )
