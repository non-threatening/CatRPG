extends Quest
class_name Blank


@export_category("Steps")


@export var step_list: Array[ QuestStep ]


func update(_args: Dictionary = {}) -> void:
	updated.emit()


func complete(_args: Dictionary = {}) -> void:

	pass
