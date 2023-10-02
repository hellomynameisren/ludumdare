extends CharacterBody2D

class_name player

var speed = 300 ## prev 250 
var jump_speed = -500
var gravity = 925 ## prev 1000
var last_wall_jump_dir = 0 # 0: No wall jump, -1: Left wall, 1: Right wall
var last_key_dir = 0 # 0: No key, -1: Left key (ui_a), 1: Right key (ui_d)

var animation_tree: AnimationTree

var fall_off_y = 1500

func _on_Animation_finished(animation_name: String):
	print("Finished Animation: ", animation_name)

func _ready():
	$AnimationPlayer.connect("animation_finished", self._on_Animation_finished)

	animation_tree = $AnimationTree
	animation_tree.set_active(true)
	animation_tree.set("parameters/playback", "idle")
	
	var tilemap = get_parent().get_node("TileMap")
	if tilemap:
		var tilecoords = tilemap.get_used_rect().end
		fall_off_y = tilemap.to_global(tilemap.map_to_local(tilecoords)).y + 800
		
	#$AnimatedSprite2D.play("default")

var prev_state = ""
var prev_animation = ""

func update_animation_parameters():
	var current_state = $AnimationTree.get("parameters/playback").get_current_node()
	var current_animation = $AnimationPlayer.current_animation

	if current_state != prev_state:
		# print("State changed! Current State: " + str(current_state))
		prev_state = current_state

	if current_animation != prev_animation:
		# print("Animation changed! Currently playing: ", current_animation)
		prev_animation = current_animation

	if velocity.y < 0:
		animation_tree["parameters/conditions/is_jumping"] = true
		animation_tree["parameters/conditions/is_falling"] = false
		animation_tree["parameters/conditions/is_running"] = false
		animation_tree["parameters/conditions/is_idle"] = false
	elif velocity.y > 0:
		animation_tree["parameters/conditions/is_jumping"] = false
		animation_tree["parameters/conditions/is_falling"] = true
		animation_tree["parameters/conditions/is_running"] = false
		animation_tree["parameters/conditions/is_idle"] = false
		
		if global_position.y > fall_off_y:
			animation_tree["parameters/conditions/is_falling_off"] = true
	else:
		animation_tree["parameters/conditions/is_jumping"] = false
		animation_tree["parameters/conditions/is_falling"] = false
		if velocity.x == 0:
			animation_tree["parameters/conditions/is_idle"] = true
			animation_tree["parameters/conditions/is_running"] = false
		else:
			animation_tree["parameters/conditions/is_idle"] = false
			animation_tree["parameters/conditions/is_running"] = true
	if not level_ended():
		if velocity.x < 0:
			$Sprite2D.flip_h = true
		elif velocity.x > 0:
			$Sprite2D.flip_h = false
	
	
func level_ended():
	var parent = get_parent()
	if parent is level:
		return parent.level_ended
	return false

func get_input():
	var input_vector = Vector2.ZERO
	if level_ended():
		return input_vector
	input_vector.x = Input.get_action_strength("ui_d") - Input.get_action_strength("ui_a")
	velocity.x = input_vector.x * speed
	#if Input.is_action_pressed("ui_d"):
	#	$Sprite2D.flip_h = false  # No flip
	#	if is_on_floor():
	#		$AnimationPlayer.play("run")
	#elif Input.is_action_pressed("ui_a"):
	#	$Sprite2D.flip_h = true  # Flip
	#	if is_on_floor():
	#		$AnimationPlayer.play("run")
	#else:
	#	if is_on_floor():
	#		$AnimationPlayer.play("rest", false)
	return input_vector


func _physics_process(delta):
	var input_vector = get_input()
	
	if is_on_floor():
		if Input.is_action_just_pressed("ui_w"):
			velocity.y = jump_speed
			$AudioStreamPlayer2D.play()
			# $AnimationPlayer.play("jump")
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
			# $AnimationPlayer.play("jump")
		# If the player is touching the right wall, didn't jump off a right wall last time, and the last key pressed wasn't right
		elif velocity.x > 0 and last_wall_jump_dir != 1 and last_key_dir != 1:
			velocity.y = jump_speed
			velocity.x = -speed
			last_wall_jump_dir = 1
			# $AnimationPlayer.play("jump")

	# Reset last_wall_jump_dir when touching the ground or opposite wall
	if is_on_floor() or (input_vector.x > 0 and last_wall_jump_dir == -1) or (input_vector.x < 0 and last_wall_jump_dir == 1):
		last_wall_jump_dir = 0
	if not level_ended():
		move_and_slide()

	# Existing collision checks...
	

	if is_on_wall():
		velocity.x = 0
		
	if global_position.y > 3000:
		$AudioStreamPlayer2D2.play()
		get_parent().go_to_game_over_scene()
	
	# Check for lava collision
	for idx in get_slide_collision_count():
		var body = get_slide_collision(idx)
		if body.get_collider() is lava_block:
			$AudioStreamPlayer2D2.play()
			get_parent().go_to_game_over_scene()
		## in hazard group
		if body.get_collider().is_in_group("hazard"):
			$AudioStreamPlayer2D2.play()
			get_parent().go_to_game_over_scene()
		if body.get_collider().is_in_group("thwomp"):
			velocity.y *= 2
		if body.get_collider() is goal:
			get_parent().go_to_you_win_scene()
			
	update_animation_parameters()
			
