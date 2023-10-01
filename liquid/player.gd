extends CharacterBody2D

class_name player

var speed = 300 ## prev 250 
var jump_speed = -500
var gravity = 850 ## prev 1000
var last_wall_jump_dir = 0 # 0: No wall jump, -1: Left wall, 1: Right wall
var last_key_dir = 0 # 0: No key, -1: Left key (ui_a), 1: Right key (ui_d)


func _ready():
	pass
	#$AnimatedSprite2D.play("default")


func get_input():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_d") - Input.get_action_strength("ui_a")
	velocity.x = input_vector.x * speed
	if Input.is_action_pressed("ui_d"):
		$Sprite2D.flip_h = false  # No flip
		if is_on_floor():
			$AnimationPlayer.play("run")
	elif Input.is_action_pressed("ui_a"):
		$Sprite2D.flip_h = true  # Flip
		if is_on_floor():
			$AnimationPlayer.play("run")
	else:
		if is_on_floor():
			$AnimationPlayer.play("rest", false)
	return input_vector


func _physics_process(delta):
	var input_vector = get_input()
	
	if is_on_floor():
		if Input.is_action_just_pressed("ui_w"):
			velocity.y = jump_speed
			$AnimationPlayer.play("jump")
		else:
			velocity.y = 0
	else:
		velocity.y += gravity * delta

	# Wall Jump Logic
	if is_on_wall() and Input.is_action_just_pressed("ui_w"):
		# If the player is touching the left wall, didn't jump off a left wall last time, and the last key pressed wasn't left
		if velocity.x < 0 and last_wall_jump_dir != -1 and last_key_dir != -1:
			velocity.y = jump_speed
			velocity.x = speed
			last_wall_jump_dir = -1
			$AnimationPlayer.play("jump")
		# If the player is touching the right wall, didn't jump off a right wall last time, and the last key pressed wasn't right
		elif velocity.x > 0 and last_wall_jump_dir != 1 and last_key_dir != 1:
			velocity.y = jump_speed
			velocity.x = -speed
			last_wall_jump_dir = 1
			$AnimationPlayer.play("jump")

	# Reset last_wall_jump_dir when touching the ground or opposite wall
	if is_on_floor() or (input_vector.x > 0 and last_wall_jump_dir == -1) or (input_vector.x < 0 and last_wall_jump_dir == 1):
		last_wall_jump_dir = 0

	move_and_slide()

	# Existing collision checks...
	

	if is_on_wall():
		velocity.x = 0
	
	# Check for lava collision
	for idx in get_slide_collision_count():
		var body = get_slide_collision(idx)
		if body.get_collider() is lava_block:
			get_parent().go_to_game_over_scene()
		## in hazard group
		if body.get_collider().is_in_group("hazard"):
			get_parent().go_to_game_over_scene()
		if body.get_collider() is goal:
			get_parent().go_to_you_win_scene()
			
