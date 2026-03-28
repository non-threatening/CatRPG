class_name Options extends Control

@onready var check_censor: CheckButton = $CheckCensor


func _ready() -> void:
	check_censor.toggled.connect( _censor )

	visibility_changed.connect( _set_prefs )


func _set_prefs() -> void:
	check_censor.set_pressed_no_signal( SaveManager.censored )


func _censor( _b ) -> void:
	SaveManager.censored = _b
