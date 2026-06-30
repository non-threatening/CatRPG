extends VBoxContainer

@onready var distance_1: ButtonHiHat = $"../distance1"


func _ready() -> void:
	distance_1.pressed.connect( _update_bf_distance )
	

func _update_bf_distance() -> void:
	var bf_dist = StatsManager.npcs_stats.bf_distance
	# distance caps at 3
	if bf_dist < 3:
		StatsManager.npcs_stats.bf_distance = bf_dist + 1
