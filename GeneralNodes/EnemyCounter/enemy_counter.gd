class_name EnemyCounter extends Node2D


signal enemies_defeated


func _ready() -> void:
	child_exiting_tree.connect( _on_enemy_destroyied )
	pass
	

func _on_enemy_destroyied( e : Node2D ) -> void:
	if e is Enemy:
		if enemy_count() <= 1: # check against 1 because it's the last enemy, then it's gone
			enemies_defeated.emit()
	pass
	
	
func enemy_count() -> int:
	var _count : int = 0
	for c in get_children():
		if c is Enemy:
			_count += 1
	return _count
