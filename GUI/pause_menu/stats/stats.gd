class_name Stats extends PanelContainer

@onready var level: Label = %Level
@onready var xp: Label = %XP
@onready var attack: Label = %Attack
@onready var defense: Label = %Defense
@onready var attack_change: Label = %Attack_change
@onready var defense_change: Label = %Defense_change



func _ready() -> void:
	PauseMenu.shown.connect( update_stats )
	
	
func update_stats() -> void:
	var _p : Player = PlayerManager.player
	level.text = str( _p.level )
	
	if _p.level < PlayerManager.level_requirments.size():
		xp.text = str( _p.xp ) + "/" + str(PlayerManager.level_requirments[ _p.level ])
	else:
		xp.text = "Max Level"
	attack.text = str( _p.attack )
	defense.text = str( _p.defense )
