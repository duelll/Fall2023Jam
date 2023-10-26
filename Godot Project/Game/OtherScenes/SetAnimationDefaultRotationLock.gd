extends AnimatedSprite2D

@export var defaultRotation = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_rotation = defaultRotation
