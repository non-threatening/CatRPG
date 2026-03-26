class_name HSliderHiHat extends HSlider

const HI_HAT__10_ = preload("uid://u7bfr1mauqbt")


func _ready() -> void:
	value_changed.connect( _on_value_changed )
	
func _on_value_changed( _t ) -> void:
	prints( _t )
	PauseMenu.play_audio( HI_HAT__10_ )
