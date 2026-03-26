class_name ButtonHiHat extends Button

const HI_HAT__10_ = preload("uid://u7bfr1mauqbt")
const CLAP__2_ = preload("uid://bgmimlxly3wpv")

@export var focus_sound : AudioStream = HI_HAT__10_
@export var pressed_sound : AudioStream = CLAP__2_


func _ready() -> void:
	focus_entered.connect( on_focus_entered )
	focus_exited.connect( on_focus_exited )
	button_up.connect( on_button_up )
	pivot_offset_ratio = Vector2( 0.5, 0.5 )


func on_focus_entered() -> void:
	PauseMenu.play_audio( focus_sound )
	var tween_entered = create_tween()
	tween_entered.tween_property( self, "scale", Vector2( 1.1, 1.1 ), 0.2 )
	#scale = Vector2( 1.1, 1.1 )

func on_focus_exited() -> void:
	#scale = Vector2( 1.0, 1.0 )
	var tween_exited = create_tween()
	tween_exited.tween_property( self, "scale", Vector2( 1.0, 1.0 ), 0.2 )


func on_button_up() -> void:
	await get_tree().process_frame
	PauseMenu.play_audio( pressed_sound )
