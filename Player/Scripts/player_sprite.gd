extends Sprite2D

const PLAYER = preload("uid://b4d5u50y4e3og")
const PLAYER_LOKTIN = preload("uid://b3iybtj0bph5k")

@onready var sprite: Sprite2D = $"."


func _ready() -> void:
	LevelManager.level_loaded.connect( _check_level )
	
	
func _check_level() -> void:
	var thing = get_tree().get_current_scene().name
	if thing == "TheLobby":
		sprite.material.shader = PLAYER_LOKTIN
	else:
		sprite.material.shader = PLAYER
