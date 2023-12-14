extends Area2D

enum CaptureStates 
{
	IDLE = 0,
	FIRING = 1,
	BULLET = 2,
	MISSILE = 3,
	SPREAD = 4,
	RETURNING = 5, 
	RETURNING_BULLET = 6, 
	RETURNING_MISSILE = 7,
	RETURNING_SPREAD = 8,
}

var state = CaptureStates.IDLE
@export var pod_bullet : PackedScene
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
	if(state == CaptureStates.FIRING):
		position += transform.x * speed * delta
	if(state == CaptureStates.RETURNING or state == CaptureStates.RETURNING_BULLET or state == CaptureStates.RETURNING_MISSILE or state == CaptureStates.RETURNING_SPREAD):
		position -= transform.x * speed * delta
		
func get_input():
	if Input.is_action_just_pressed("firePod"):
		if state == CaptureStates.IDLE:
			state = CaptureStates.FIRING
	if Input.is_action_just_pressed("shoot"):
		if (state == CaptureStates.BULLET and can_shoot == true):
			var inst = pod_bullet.instantiate()
			get_tree().current_scene.add_child(inst)
			#inst.transform = $FrontBarrel.global_transform
			inst.set_position($BulletSpawner.get_global_position())
			can_shoot = false
			$BulletTimer.wait_time = 0.3
			$BulletTimer.start()
		if (state == CaptureStates.MISSILE and can_shoot == true):
			var inst = player_missile.instantiate()
			get_tree().current_scene.add_child(inst)
			#inst.transform = $FrontBarrel.global_transform
			inst.set_position($BulletSpawner.get_global_position())
			can_shoot = false
			$BulletTimer.wait_time = 1.1
			$BulletTimer.start()
		if (state == CaptureStates.SPREAD and can_shoot == true):
			for angle in [-0.5,0,0.5]:
				var inst = pod_bullet.instantiate()
				get_tree().current_scene.add_child(inst)
				#inst.transform = $FrontBarrel.global_transform
				inst.set_position($BulletSpawner.get_global_position())
				inst.rotation = rotation + angle
			can_shoot = false
			$BulletTimer.wait_time = 0.7
			$BulletTimer.start()
			
func _on_body_entered(body):
	if (state == CaptureStates.FIRING):
		if body.is_in_group("capturable_enemies"):
			$CaptureAudioPlayer.play()
			body.take_damage(10)
			if body.is_in_group("bullet_enemy"):
				state = CaptureStates.RETURNING_BULLET
				$AnimatedSprite2D.play("bullet")
			elif body.is_in_group("missile_enemy"):
				state = CaptureStates.RETURNING_MISSILE
				$AnimatedSprite2D.play("missile")
			elif body.is_in_group("spread_enemy"):
				state = CaptureStates.RETURNING_SPREAD
				$AnimatedSprite2D.play("spread")
	elif state == CaptureStates.RETURNING:
		if body.is_in_group("player"):
			state = CaptureStates.IDLE
	elif state == CaptureStates.RETURNING_BULLET:
		if body.is_in_group("player"):
			state = CaptureStates.BULLET
			$CaptureTimer.start()
	elif state == CaptureStates.RETURNING_MISSILE:
		if body.is_in_group("player"):
			state = CaptureStates.MISSILE
			$CaptureTimer.start()
	elif state == CaptureStates.RETURNING_SPREAD:
		if body.is_in_group("player"):
			state = CaptureStates.SPREAD
			$CaptureTimer.start()

func _on_area_entered(area):
	if state == CaptureStates.FIRING:
		if area.is_in_group("pod_limit"):
			state = CaptureStates.RETURNING

func _on_capture_timer_timeout():
	state = CaptureStates.IDLE
	$AnimatedSprite2D.play("default")

func _on_bullet_timer_timeout():
	can_shoot = true
