extends AnimatableBody2D

@export var enemy_bullet : PackedScene
@export var health = 10
@onready var Player = get_parent().get_node("MainCamera").get_node("Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (health < 1):
		$AnimatedSprite2D.play("death")
		await $AnimatedSprite2D.animation_finished
		queue_free()
	
func _on_timer_timeout():
	shoot()

func shoot():
	actually_shoot()
	
func actually_shoot():
	for angle in [-0.6,-0.3,0,0.3,0.6]:
		var inst = enemy_bullet.instantiate()
		inst.color = "blue"
		owner.add_child(inst)
	
		inst.speed = 50
		#inst.transform = $FrontBarrel.global_transform
		inst.set_position($ShootLocation.get_global_position())
		inst.rotation = $ShootLocation.rotation + angle

func _on_area_2d_body_entered(body):
	if(body.is_in_group("player")):
		get_tree().reload_current_scene()