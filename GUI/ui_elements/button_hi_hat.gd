class_name ButtonHiHat extends Button

const HI_HAT__10_ = preload("uid://u7bfr1mauqbt")


func _ready() -> void:
	focus_entered.connect( _on_focus )

func _on_focus() -> void:
	PauseMenu.play_audio( HI_HAT__10_ )
