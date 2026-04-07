extends Control

const STAT_DISPLAY_BUTTON = preload("uid://ia11y5hkgfa8")
const ACH_DISPLAY_BUTTON = preload("uid://cg6j64vd6ka33")

@onready var v_box_container: VBoxContainer = $ScrollContainer/HBoxContainer/VBoxContainer
@onready var v_box_container_2: VBoxContainer = $ScrollContainer/HBoxContainer/VBoxContainer2

func _ready() -> void:
	visibility_changed.connect( _on_visible_changed )


func _on_visible_changed() -> void:
	clear_list()
	var info_list : Dictionary = StatsManager.stats
	for key in info_list.keys():
		var display : DisplayStats = STAT_DISPLAY_BUTTON.instantiate()
		v_box_container.add_child( display )
		display.initialize( key, info_list[key] )
		
	var ach_list : Dictionary = StatsManager.achievements
	for key in ach_list.keys():
		if ach_list[key] == 0:
			return
		var display : DisplayAch = ACH_DISPLAY_BUTTON.instantiate()
		v_box_container_2.add_child( display )
		display.initialize( key, ach_list[key] )
		

func clear_list() -> void:
	for d in v_box_container.get_children():
		d.queue_free()
	for d in v_box_container_2.get_children():
		d.queue_free()
