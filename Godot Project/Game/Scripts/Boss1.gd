extends AnimatableBody2D

enum States
{
	MOVING = 0,
	RECHARGING = 1,
	DEAD = 2,
	DEFAULT = 3
}

@export var enemy_bullet : PackedScene
@export var enemy_laser : PackedScene
@export var health = 30
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
	elif(state == States.DEFAULT):
		if (Camera.scroll_speed == 0):
			state = States.MOVING
			$AnimatedSprite2D.play("attackLoop")
	
func _on_timer_timeout():
	state = States.MOVING
	$AnimatedSprite2D.play("attackLoop")

func shoot():
	actually_shoot()
	
func actually_shoot():
	$ShootAudioPlayer.play()
	for angle in [-1, -0.7, -0.6, -0.5, -0.4, 0.4, 0.5 , 0.6, 0.7, 1]:
		var inst = enemy_bullet.instantiate()
		get_tree().current_scene.add_child(inst)
		inst.speed = 90
		inst.color = "pink"
		#inst.transform = $FrontBarrel.global_transform
		if get_node_or_null("ShootLocation") != null:
			inst.set_position($ShootLocation.get_global_position())
			inst.position.x += 25
			inst.rotation = PI + angle
		else:
			inst.queue_free()
	
func laser_shoot():
	var inst = enemy_laser.instantiate()
	get_tree().current_scene.add_child(inst)
	inst.speed = 70
	#inst.color = "pink"
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
	if(state != States.DEFAULT):
		health -= amount
	
		if (health < 1):
			if death_processed == false:
				$EnemyDeathAudioPlayer.play()
				state = States.DEAD
				$Area2D.queue_free()
				$CollisionShape2D.queue_free()
				$ShootLocation.queue_free()
				death_processed = true
			$AnimatedSprite2D.play("death")
			await $AnimatedSprite2D.animation_finished
			queue_free()
			get_tree().change_scene_to_file("res://Menus/EndScreen.tscn")

func _on_visible_on_screen_notifier_2d_screen_entered():
	pass
	#state = States.MOVING
	#$AnimatedSprite2D.play("attackLoop")

func _on_animated_sprite_2d_frame_changed():
	if((state == States.MOVING)):
		shoot()

func _on_animated_sprite_2d_animation_finished():
	laser_shoot()
	state = States.RECHARGING
	$Timer.start()
