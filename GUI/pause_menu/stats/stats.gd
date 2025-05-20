class_name Stats extends PanelContainer

@onready var level: Label = $VBoxContainer/HBoxContainer/Level
@onready var xp: Label = $VBoxContainer/HBoxContainer2/XP
@onready var attack: Label = $VBoxContainer/HBoxContainer3/Attack
@onready var defense: Label = $VBoxContainer/HBoxContainer4/Defense



func _ready() -> void:
	PauseMenu.shown.connect( update_stats )
	
	
func update_stats() -> void:
	var _p : Player = PlayerManager.player
	level.text = str( _p.level )
	xp.text = str( _p.xp ) + "/" + str(PlayerManager.level_requirments[ _p.level ])
	attack.text = str( _p.attack )
	defense.text = str( _p.defense )
