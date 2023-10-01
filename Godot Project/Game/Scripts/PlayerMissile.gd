extends Area2D

@export var player_explosion : PackedScene
@export var speed = 20

func _ready():
	$AnimatedSprite2D.play("default")

func _physics_process(delta):
	position += transform.x * speed * delta
	if not get_node("ScreenNotifier").is_on_screen():
		queue_free()

func _on_body_entered(body):
	pass

func _on_animated_sprite_2d_animation_finished():
	explode()
	queue_free()
	
func explode():
	var inst = player_explosion.instantiate()
	get_parent().add_child(inst)
	inst.set_position($Marker2D.get_global_position())
