extends Control

const STAT_DISPLAY_BUTTON = preload("uid://ia11y5hkgfa8")

@onready var display_stats: DisplayStats = $ScrollContainer/VBoxContainer/DisplayStats
@onready var v_box_container: VBoxContainer = $ScrollContainer/VBoxContainer


func _ready() -> void:
	visibility_changed.connect( _on_visible_changed )


func _on_visible_changed() -> void:
	clear_list()
	var info_list : Dictionary = StatsManager.stats
	for key in info_list.keys():
		var display : DisplayStats = STAT_DISPLAY_BUTTON.instantiate()
		v_box_container.add_child( display )
		display.initialize( key, info_list[key] )
		

func clear_list() -> void:
	for d in v_box_container.get_children():
		d.queue_free()
