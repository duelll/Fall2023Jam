extends Camera2D

var scroll_speed

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	horizontal_scroll()
	
func horizontal_scroll():
	position.x += 0.5
