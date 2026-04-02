extends VBoxContainer

@onready var h_slider: HSliderHiHat = $Slider/HSliderHiHat
@onready var label_2: Label = $Slider/HBoxContainer/Label2


func _ready() -> void:
	h_slider.value_changed.connect( _on_value_changed )
	visibility_changed.connect( _set_prefs )	


func _on_value_changed( _v ) -> void:
	var value = ( _v - 0.04 ) * -1
	label_2.text = show_text( value )
	SaveManager.talk_speed = value


func _set_prefs() -> void:
	h_slider.value = ( SaveManager.talk_speed - 0.04 ) * -1
	label_2.text = show_text( SaveManager.talk_speed )


func show_text( _t ) -> String:
	var thing = int( _t * 1000 )
	match thing:
		0: return "Instant"
		4: return "Fastest"
		10: return "Faster"
		15: return "Fast"
		20: return "Normal"
		25: return "Slow"
		30: return "Slower"
		35: return "Slowest"
		40: return "Slowester"
		_: return "Normal"
