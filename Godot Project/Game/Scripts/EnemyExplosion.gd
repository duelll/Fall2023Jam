extends Area2D

func _ready():
	$AnimatedSprite2D.play("default")

func _physics_process(delta):
	if not get_node("ScreenNotifier").is_on_screen():
		queue_free()

func _on_body_entered(body):
	if(body.is_in_group("player")):
		body.death()

func _on_animated_sprite_2d_animation_finished():
	queue_free()
