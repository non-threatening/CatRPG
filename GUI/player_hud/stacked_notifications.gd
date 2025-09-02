class_name StackedNotificationUI extends Control

const STACKED_NOTIFICATION = preload("res://GUI/player_hud/stacked_notification.tscn")

var notification_queue : Array
var gate : bool = true
var counter : int = 0

@onready var panel_container_2: PanelContainer = $PanelContainer2
@onready var v_box_container: VBoxContainer = $PanelContainer2/VBoxContainer


func _ready() -> void:
	for c in v_box_container.get_children():
		c.queue_free()


func add_notification_to_queue( _title : String, _message : String ) -> void:
	notification_queue.append({
		title = _title,
		message = _message 
	})
	if gate:
		display_quest_notification()
		gate = false

	
func display_quest_notification() -> void:
	var _n = notification_queue.pop_front()
	if _n == null:
		gate = true
		counter = 0
		return
	counter += 1
	var new_notification : StackNotification = STACKED_NOTIFICATION.instantiate()
	v_box_container.add_child( new_notification )
	new_notification.initialize( _n.title, _n.message, counter )
	
	await get_tree().create_timer( 3.0 ).timeout
	display_quest_notification()
