class_name ArelCrashSite extends Level

@onready var bird_friend: BirdFriend = $BirdFriend


func _ready() -> void:
	super()
	bird_friend.show()
