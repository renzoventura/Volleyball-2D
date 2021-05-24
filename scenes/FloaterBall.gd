extends "res://scenes/TemplateBall.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	print("float")
	LIST_OF_INITIAL_SPINS = [0]
	LIST_OF_INITIAL_SPEEDS = {200:140}
	LIST_OF_WOBBLE_LEVELS = [1, 1, 3, 3, 3, 6, 10]
	LIST_OF_GRAVITY_SCALES = [1,]



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
