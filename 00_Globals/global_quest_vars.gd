extends Node

var qvars = {
	#	[101] Walking Quest
	flower_count = 0
}

func _ready() -> void:
	SaveManager.game_loaded.connect( _on_game_loaded )

func _on_game_loaded() -> void:
	qvars = SaveManager.current_save.qvars
