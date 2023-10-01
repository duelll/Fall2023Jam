extends Area2D

var state = "idle"
@export var player_bullet : PackedScene
@export var player_missile : PackedScene
@export var speed = 200
@export var can_shoot = true

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
	if Input.is_action_just_pressed("shoot"):
		if (state == "bullet" and can_shoot == true):
			var inst = player_bullet.instantiate()
			owner.add_child(inst)
			#inst.transform = $FrontBarrel.global_transform
			inst.set_position($Marker2D.get_global_position())
			can_shoot = false
			$BulletTimer.wait_time = 0.3
			$BulletTimer.start()
		if (state == "missile" and can_shoot == true):
			var inst = player_missile.instantiate()
			owner.add_child(inst)
			#inst.transform = $FrontBarrel.global_transform
			inst.set_position($Marker2D.get_global_position())
			can_shoot = false
			$BulletTimer.wait_time = 1.1
			$BulletTimer.start()
		if (state == "spread" and can_shoot == true):
			for angle in [-0.5,0,0.5]:	
				var inst = player_bullet.instantiate()
				owner.add_child(inst)
				#inst.transform = $FrontBarrel.global_transform
				inst.set_position($Marker2D.get_global_position())
				inst.rotation = rotation + angle
			can_shoot = false
			$BulletTimer.wait_time = 0.7
			$BulletTimer.start()
			
func _on_body_entered(body):
	if state == "shooting":
		if body.is_in_group("capturable_enemies"):
			if body.is_in_group("bullet_enemy"):
				state = "returning_bullet"
				$AnimatedSprite2D.play("bullet")
			elif body.is_in_group("missile_enemy"):
				state = "returning_missile"
				$AnimatedSprite2D.play("missile")
			elif body.is_in_group("spread_enemy"):
				state = "returning_spread"
				$AnimatedSprite2D.play("spread")
	elif state == "returning":
		if body.is_in_group("player"):
			state = "idle"
	elif state == "returning_bullet":
		if body.is_in_group("player"):
			state = "bullet"
			$CaptureTimer.start()
	elif state == "returning_missile":
		if body.is_in_group("player"):
			state = "missile"
			$CaptureTimer.start()
	elif state == "returning_spread":
		if body.is_in_group("player"):
			state = "spread"
			$CaptureTimer.start()

func _on_area_entered(area):
	if state == "shooting":
		if area.is_in_group("pod_limit"):
			state = "returning"

func _on_capture_timer_timeout():
	state = "idle"
	$AnimatedSprite2D.play("default")

func _on_bullet_timer_timeout():
	can_shoot = true
