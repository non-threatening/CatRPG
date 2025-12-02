@tool
@icon( "res://npc/icons/npc.svg" )
class_name WolfNPC extends NPC

@onready var actionable: Area2D = $ActionableDialog
@onready var indicator_2d: InteractIndicator = $Indicator2D

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	super()
	TimeSystem.time_tick.time_unit_changed.connect( _on_time_unit_changed )
	_on_time_unit_changed( "moon", TimeSystem.time_tick.get_time_unit("moon"), 0 )
	

func _on_time_unit_changed( unit_name: String, new_value: int, old_value: int ) -> void:
	match unit_name:
		"moon":
			if new_value == 7 or new_value == 0 or new_value == 1:
				modulate = Color(1.0, 1.0, 1.0, 0.251)
				actionable.monitoring = false
				actionable.monitorable = false
				indicator_2d.monitoring = false
			else:
				modulate = Color(1.0, 1.0, 1.0, 1.0)
				actionable.monitoring = true
				actionable.monitorable = true
				indicator_2d.monitoring = true
