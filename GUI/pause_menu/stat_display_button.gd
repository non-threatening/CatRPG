class_name DisplayStats extends ButtonHiHat

@onready var label: Label = $Label
@onready var label_2: Label = $Label2

func initialize( stat_name : String, amount : int ) -> void:
	label.text = stat_name.capitalize()
	label_2.text = NumberToWords.to_words( int(amount) ).capitalize()
	disabled = true
