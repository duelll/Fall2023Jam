extends AnimatableBody2D

enum States
{
	IDLE = 0,
	ADVANCING = 1,
	PRERETREATING = 2,
	RETREATING = 3,
}

@export var enemy_bullet : PackedScene
@export var health = 1
@export var forwardSpeed = 0.5
@export var usePreretreat = true
@export var preretreatVector = Vector2(1.5, -1.5)
@export var retreatVector = Vector2(2,0)
@onready var Player = get_tree().current_scene.get_node("MainCamera").get_node("Player")
@onready var Camera = get_tree().current_scene.get_node("MainCamera")

var death_processed = false
var preretreatDistanceCheckStart
var state = States.IDLE

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var a = position.direction_to(Player.global_position).angle()
	rotation = snapped(a, PI/8)
	
	if (state == States.ADVANCING):
		move_and_collide(Vector2(forwardSpeed * -1,0))
		if (position.x <= Camera.get_screen_center_position().x - 25):
			shoot()
			if (usePreretreat == true):
				state = States.PRERETREATING
				$Timer.start()
			else:
				state = States.RETREATING
	elif(state == States.PRERETREATING):
		move_and_collide(preretreatVector)
	elif (state == States.RETREATING):
		move_and_collide(retreatVector)
	
	
func _on_timer_timeout():
	state = States.RETREATING

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
		inst.rotation = rotation
	else:
		inst.queue_free()

func _on_area_2d_body_entered(body):
	if(body.is_in_group("player")):
		body.death()
		
func take_damage(amount):
	health -= amount
	
	if (health < 1):
		if death_processed == false:
			$EnemyDeathAudioPlayer.play()
			state = States.IDLE
			$Area2D.queue_free()
			$CollisionShape2D.queue_free()
			$ShootLocation.queue_free()
			death_processed = true
		$AnimatedSprite2D.play("death")
		await $AnimatedSprite2D.animation_finished
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_entered():
	state = States.ADVANCING


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
