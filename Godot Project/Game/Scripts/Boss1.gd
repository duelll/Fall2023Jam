extends AnimatableBody2D

enum States
{
	MOVING = 0,
	RECHARGING = 1,
	DEAD = 2,
	DEFAULT = 3
}

@export var enemy_bullet : PackedScene
@export var health = 1
@export var verticalSpeed = 0.5;
@onready var Player = get_tree().current_scene.get_node("MainCamera").get_node("Player")
@onready var Camera = get_tree().current_scene.get_node("MainCamera")

var death_processed = false
var preretreatDistanceCheckStart
var state = States.DEFAULT

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if (state == States.MOVING):
		move_and_collide(Vector2(0,verticalSpeed))
		if ((position.y <= Camera.get_screen_center_position().y - 50) or (position.y >= Camera.get_screen_center_position().y + 50)):
			verticalSpeed *= -1	
	
func _on_timer_timeout():
	state = States.MOVING
	$AnimatedSprite2D.play("attackLoop")

func shoot():
	actually_shoot()
	
func actually_shoot():
	var inst = enemy_bullet.instantiate()
	get_tree().current_scene.add_child(inst)
	inst.speed = 70
	inst.color = "pink"
	#inst.transform = $FrontBarrel.global_transform
	if get_node_or_null("ShootLocation") != null:
		inst.set_position($ShootLocation.get_global_position())
		inst.rotation = PI
	else:
		inst.queue_free()

func _on_area_2d_body_entered(body):
	if(body.is_in_group("player")):
		body.death()
		
func take_damage(amount):
	health -= amount
	
	if (health < 1):
		if death_processed == false:
			state = States.DEAD
			$Area2D.queue_free()
			$CollisionShape2D.queue_free()
			$ShootLocation.queue_free()
			death_processed = true
		$AnimatedSprite2D.play("death")
		await $AnimatedSprite2D.animation_finished
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_entered():
	state = States.MOVING
	$AnimatedSprite2D.play("attackLoop")

func _on_animated_sprite_2d_frame_changed():
	shoot()

func _on_animated_sprite_2d_animation_finished():
	state = States.RECHARGING
	$Timer.start()
