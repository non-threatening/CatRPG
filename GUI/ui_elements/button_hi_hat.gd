class_name ButtonHiHat extends Button

const HI_HAT__10_ = preload("uid://u7bfr1mauqbt")
const KICK__7_ = preload("uid://bgdpmxn86hpae")

@export var focus_sound : AudioStream = HI_HAT__10_
@export var pressed_sound : AudioStream = KICK__7_


func _ready() -> void:
	focus_entered.connect( on_focus_entered )
	focus_exited.connect( on_focus_exited )
	button_up.connect( on_button_up )
	pivot_offset_ratio = Vector2( 0.5, 0.5 )


func on_focus_entered() -> void:
	AudioManager.play_ui( focus_sound )
	var tween_entered = create_tween()
	tween_entered.tween_property( self, "scale", Vector2( 1.125, 1.125 ), 0.2 )


func on_focus_exited() -> void:
	var tween_exited = create_tween()
	tween_exited.tween_property( self, "scale", Vector2( 1.0, 1.0 ), 0.2 )


func on_button_up() -> void:
	await get_tree().process_frame
	AudioManager.play_ui( pressed_sound )
