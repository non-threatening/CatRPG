class_name Stats extends PanelContainer

var inventory: InventoryData

@onready var level: Label = %Level
@onready var xp: Label = %XP
@onready var attack: Label = %Attack
@onready var defense: Label = %Defense
@onready var attack_change: Label = %Attack_change
@onready var defense_change: Label = %Defense_change



func _ready() -> void:
	PauseMenu.shown.connect( update_stats )
	PauseMenu.preview_stats_changed.connect( _on_preview_stats_changed )
	inventory = PlayerManager.INVETORY_DATA
	inventory.equipment_changed.connect( update_stats )
	
	
	
func update_stats() -> void:
	var _p : Player = PlayerManager.player
	level.text = str( _p.level )
	
	if _p.level < PlayerManager.level_requirments.size():
		xp.text = str( _p.xp ) + "/" + str(PlayerManager.level_requirments[ _p.level ])
	else:
		xp.text = "Max Level"
		
	attack.text = str( _p.attack + inventory.get_attack_bonus() )
	defense.text = str( _p.defense + inventory.get_defense_bonus() )


func _on_preview_stats_changed( item : ItemData) -> void:
	attack_change.text = ""
	defense_change.text = ""
	
	if not item is EquipableItemData:
		return
	
	var equipment : EquipableItemData = item
	var attack_delta : int = inventory.get_attack_bonus_dif( equipment )
	var defense_delta : int = inventory.get_defense_bonus_dif( equipment )
	
	update_change_label( attack_change, attack_delta )
	update_change_label( defense_change, defense_delta )
	pass

func update_change_label( label : Label, value : int ) -> void:
	if value > 0:
		label.text = "+" + str( value )
		label.modulate = Color.FOREST_GREEN
	elif value < 0:
		label.text = str( value )
		label.modulate = Color.DARK_RED
		pass
	pass
