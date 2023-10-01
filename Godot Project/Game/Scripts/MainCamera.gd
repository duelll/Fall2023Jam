extends Camera2D

@export var scroll_speed = 0.5


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	horizontal_scroll()
	
func horizontal_scroll():
	position.x += scroll_speed
