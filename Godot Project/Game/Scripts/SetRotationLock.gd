extends Node2D

@export var defaultRotation = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_rotation = defaultRotation
