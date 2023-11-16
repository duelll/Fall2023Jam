extends Camera2D

@export var scroll_speed = 27


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position.x += scroll_speed * delta
	
func horizontal_scroll():
	position.x += scroll_speed
