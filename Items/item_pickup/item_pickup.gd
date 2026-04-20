@tool
class_name ItemPickup extends CharacterBody2D

signal picked_up

const ITEM_PICKUP = preload("uid://co0nsphnunane")

@export var item_data : ItemData : set  = _set_item_data
@export var item_count : int = 1 : set = _set_item_count
@export var item_persists : bool = true
@export var light_on : bool = false

@onready var point_light: PointLight2D = $PointLight2D
@onready var area_2d: Area2D = $Area2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var count_label: Label = %CountLabel

@onready var persistant_data_picked_up: PersistantDataHandler = $PersistantDataHandler
@onready var item_pickup: ItemPickup = $"."

var collected : bool = false


func _ready() -> void:
	_update_texture()
	_update_count_label()
	point_light.visible = light_on
	if light_on:
		pulse_light()
	if Engine.is_editor_hint():
		return
	area_2d.body_entered.connect( _on_body_entered )
	
	if item_persists == true:
		persistant_data_picked_up.data_loaded.connect( _on_data_loaded )
		_set_item_existance()


func pulse_light() -> void:
	var en : float = randf_range( 1.5, 3.5 )
	var tween : Tween = create_tween()
	tween.tween_property( point_light, "energy", en, 0.666 )
	await tree_entered
	await get_tree().create_timer(1).timeout
	pulse_light()


func _set_item_existance() -> void:
	collected = persistant_data_picked_up.value
	if collected: 
		item_pickup.queue_free()
	else:
		item_pickup.show()


func _on_data_loaded() -> void:
	collected = persistant_data_picked_up.value
	pass


func _physics_process(delta: float) -> void:
	var collision_info = move_and_collide( velocity * delta )
	if collision_info:
		velocity = velocity.bounce( collision_info.get_normal() ) #set velocity of Item bounce, get_normal sets the direction
	velocity -= velocity * delta * 4 #slow it down after bounces


func _on_body_entered( b ) -> void:
	if b is Player:
		if item_data:
			if item_data.name == "Bomb":
				PlayerManager.player.bomb_count += item_count
				item_picked_up()
			elif item_data.name == "Arrow":
				PlayerManager.player.arrow_count += item_count
				item_picked_up()
			else:
				PlayerManager.INVETORY_DATA.add_item( item_data, item_count )
				item_picked_up()


func item_picked_up() -> void:
	area_2d.body_entered.disconnect( _on_body_entered )
	AudioManager.play_effect( ITEM_PICKUP )
	picked_up.emit()
	collected = true
	persistant_data_picked_up.set_value()
	queue_free()
	if item_count > 1:
		PlayerHud.queue_stacked_notification( "You've got", str(NumberToWords.to_words(item_count).capitalize(), " ", item_data.name, "s") )
	else:
		PlayerHud.queue_stacked_notification( "You've got", str(NumberToWords.to_words(item_count).capitalize(), " ", item_data.name) )


func _set_item_data( value : ItemData ) -> void:
	item_data = value
	_update_texture()
	
	
func _update_texture() -> void:
	if item_data and sprite_2d:
		sprite_2d.texture = item_data.texture


func _set_item_count( value : int ) -> void:
	item_count = value
	_update_count_label()


func _update_count_label() -> void:
	if item_data and count_label:
		count_label.text = ""
		if item_count > 1:
			count_label.text = str( item_count )
