extends VBoxContainer

var bus_index : int

@onready var h_slider: HSlider = $Slider/HSliderHiHat
#@onready var h_slider: HSliderHiHat = $HSliderHiHat
@onready var label_2: Label = $Slider/HBoxContainer/Label2


func _ready() -> void:
	h_slider.value_changed.connect( _on_value_changed )
	bus_index = AudioServer.get_bus_index( "Master" )
	visibility_changed.connect( _set_prefs )


func _on_value_changed( _v ) -> void:
	AudioServer.set_bus_volume_linear( bus_index, _v )
	label_2.text = str( 100 * float( _v ), " %" )
	SaveManager.master = _v


func _set_prefs() -> void:
	AudioServer.set_bus_volume_linear( bus_index, SaveManager.master )
	label_2.text = str( 100 * float( SaveManager.master ), " %")
	h_slider.value = SaveManager.master
