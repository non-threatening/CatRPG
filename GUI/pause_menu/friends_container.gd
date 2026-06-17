extends VBoxContainer

const FREESOUND_COMMUNITY_049044_BIRDS_CHIRPING_01_75997 = preload("uid://bxisr0rdbqx1w")
const FREESOUND_COMMUNITY_BIRDS_CHIRPING_67827 = preload("uid://dnia8g6g5ep1l")
const FREESOUND_COMMUNITY_BIRDS_CHIRPING_75156 = preload("uid://omgy3umpnbsa")
const SOUL_SERENITY_SOUNDS_BIRDS_CHIRPING_241045 = preload("uid://c7dpv886lhcgd")

@onready var distance_1: ButtonHiHat = $"../distance1"
@onready var distance_2: ButtonHiHat = $"../distance2"


func _ready() -> void:
	distance_1.pressed.connect( _update_bf_distance )
	

func _update_bf_distance() -> void:
	var bf_dist = StatsManager.npcs_stats.bf_distance
	# distance caps at 3
	if bf_dist < 3:
		StatsManager.npcs_stats.bf_distance = bf_dist + 1
