extends Node2D

@export var main_camera : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	var inst = main_camera.instantiate()
	add_child(inst)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
