extends CharacterBody2D

@export var speed = 200
@export var player_bullet : PackedScene
@export var max_bullets = 3

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	
	if Input.is_action_just_pressed("shoot"):
		shoot()

func _physics_process(delta):
	get_input()
	move_and_slide()

func shoot():
	var all_bullets = get_tree().get_nodes_in_group("player_bullets")
	if len(all_bullets) < max_bullets:
		actually_shoot()

func actually_shoot():
	var b = player_bullet.instantiate()
	owner.add_child(b)
	b.transform = $FrontBarrel.global_transform
