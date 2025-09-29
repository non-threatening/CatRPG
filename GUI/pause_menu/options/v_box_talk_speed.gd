extends VBoxContainer

var bus_index : int

@onready var h_slider: HSlider = $Slider/HSlider
@onready var label_2: Label = $Slider/HBoxContainer/Label2


func _ready() -> void:
	h_slider.value_changed.connect( _on_value_changed )
	visibility_changed.connect( _set_prefs )	


func _on_value_changed( _v ) -> void:
	var value = ( _v - 0.04 ) * -1
	label_2.text = show_text( value )
	SaveManager.talk_speed = value
	print( value )


func _set_prefs() -> void:
	h_slider.value = ( SaveManager.talk_speed - 0.04 ) * -1
	label_2.text = show_text( SaveManager.talk_speed )


func show_text( _t ) -> String:
	if _t >= 0.025:
		return "Slow"
	elif _t <= 0.015:
		if _t == 0.0:
			return "Instant"
		return "Fast"
	else:
		return "Normal"
