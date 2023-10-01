extends CharacterBody2D

@export var speed = 200
@export var bullet_speed = 250
@export var player_bullet : PackedScene
@export var max_bullets = 3

func _ready():
	$AnimatedSprite2D.play("default")

func _physics_process(delta):
	get_input()
	move_and_slide()
	
func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	
	if Input.is_action_pressed("up"):
		$AnimatedSprite2D.play("up")
	elif Input.is_action_pressed("down"):
		$AnimatedSprite2D.play("down")
	else:
		$AnimatedSprite2D.play("default")
		
	if Input.is_action_just_pressed("shoot"):
			shoot()
			
func shoot():
	var all_bullets = get_tree().get_nodes_in_group("player_bullets")
	if len(all_bullets) < max_bullets:
		actually_shoot()

func actually_shoot():
	var inst = player_bullet.instantiate()
	owner.add_child(inst)
	inst.speed = bullet_speed
	#inst.transform = $FrontBarrel.global_transform
	inst.set_position($FrontBarrel.get_global_position())
