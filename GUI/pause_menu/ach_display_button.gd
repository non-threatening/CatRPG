class_name DisplayAch extends ButtonHiHat

@onready var label: Label = $Label
@onready var label_2: Label = $Label2

func initialize( stat_name : String, amount : int ) -> void:
	pivot_offset_ratio = Vector2( 0.0, 0.5 )
	label.text = stat_name.capitalize()
	if amount > 0:
		label_2.text = "Yes!"
	disabled = true
