extends Area2D

@export_enum( "Frequency", "Thing" ) var game: int = 0

@onready var freq_lock: FreqLock = $"../FreqLock"


func action() -> void:
	print("Action mingame!!!!")
	match game:
		0:
			freq_lock.tune_freq()
		_:
			pass
