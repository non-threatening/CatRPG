class_name PersistantDataHandler extends Node

signal data_loaded
var value : bool = false


func _ready() -> void:
	get_value()
	pass
	
	
func set_value() -> void:
	SaveManager.add_persistant_value( _get_name() )
	pass
	

func get_value() -> void:
	value = SaveManager.check_persistant_value( _get_name() )
	data_loaded.emit( value )
	pass
	
	
func remove_value() -> void:
	SaveManager.remove_persistant_value( _get_name() )
	pass
	

func _get_name() -> String:
	## e.g. "res://levels/area01/01.tscn" + /treasure_chest/PersistantDataHandler
	return get_tree().current_scene.scene_file_path + "/" + get_parent().name + "/" + name
