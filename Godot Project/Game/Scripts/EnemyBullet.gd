extends Area2D

@export var speed = 30
@export var color = "pink"

func _ready():
	$AnimatedSprite2D.play(color)

func _physics_process(delta):
	position += transform.x * speed * delta
	if not get_node("ScreenNotifier").is_on_screen():
		queue_free()

func _on_body_entered(body):
	if(body.is_in_group("player")):
		body.death()
	
	queue_free()

