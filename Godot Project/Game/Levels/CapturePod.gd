extends Area2D

var state = "idle"
@export var speed = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	get_input()
	if(state == "shooting"):
		position += transform.x * speed * delta
	if(state == "returning" or state == "returning_bullet" or state == "returning_missile" or state == "returning_spread"):
		position -= transform.x * speed * delta
		
func get_input():
	if Input.is_action_just_pressed("firePod"):
		if state == "idle":
			state = "shooting"
			
func _on_body_entered(body):
	if state == "shooting":
		if body.is_in_group("capturable_enemies"):
			if body.is_in_group("bullet_enemy"):
				state = "returning_bullet"
			elif body.is_in_group("missile_enemy"):
				state = "returning_missile"
			elif body.is_in_group("spread_enemy"):
				state = "returning_spread"				
	elif state == "returning":
		if body.is_in_group("player"):
			state = "idle"
	elif state == "returning_bullet":
		if body.is_in_group("player"):
			state = "bullet"
	elif state == "returning_missile":
		if body.is_in_group("player"):
			state = "missile"
	elif state == "returning_spread":
		if body.is_in_group("player"):
			state = "spread"
