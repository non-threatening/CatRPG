class_name DropData extends Resource

@export var item : ItemData ## Item resource e.g. gem.tres 
@export_range( 0, 100, 1, "suffix:%" ) var probability : float = 100
@export_range( 1, 10, 1, "suffix:items" ) var min_amount : int = 1
@export_range( 1, 10, 1, "suffix:items" ) var max_amount : int = 1


func get_drop_count() -> int:
	if randf_range( 0, 100 ) >= probability: #if probability is 80%, this needs to be higher than 80 to trigger
		return 0
	return randi_range( min_amount, max_amount ) #return random int
