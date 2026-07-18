class_name ShopStone extends Node2D

@export var shop_inventory : Array[ ItemData ]
@onready var interact_area: Area2D = $InteractArea2D


func _ready() -> void:
	interact_area.area_entered.connect( _on_area_enter )
	interact_area.area_exited.connect( _on_area_exit )
	pass


func show_shop_menu() -> void:
	ShopMenu.show_menu( shop_inventory )
	pass



func _on_area_enter( _a : Area2D ) -> void:
	PlayerManager.interact_pressed.connect( show_shop_menu )
	pass
	
func _on_area_exit( _a : Area2D ) -> void:
	PlayerManager.interact_pressed.disconnect( show_shop_menu )
	pass
