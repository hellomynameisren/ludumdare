extends CharacterBody2D

var speed = 250 
var jump_speed = -500
var gravity = 1000


func _ready():
	$AnimatedSprite2D.play("default")


func get_input():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_d") - Input.get_action_strength("ui_a")
	velocity.x = input_vector.x * speed
	if Input.is_action_pressed("ui_d"):
		$AnimatedSprite2D.flip_h = false  # No flip
		$AnimatedSprite2D.play("run_right")
	elif Input.is_action_pressed("ui_a"):
		$AnimatedSprite2D.flip_h = true  # Flip
		$AnimatedSprite2D.play("run_right")
	else:
		$AnimatedSprite2D.play("stop_right", false)
	return input_vector


func _physics_process(delta):
	var input_vector = get_input()
  
	if is_on_floor():
		if Input.is_action_just_pressed("ui_w"):
			velocity.y = jump_speed
		else:
			velocity.y = 0
	else:
		velocity.y += gravity * delta

	move_and_slide()

	if is_on_wall():
		velocity.x = 0
	
	# Check for lava collision
	for idx in get_slide_collision_count():
		var body = get_slide_collision(idx)
		if body.get_collider() is lava_block:
			go_to_game_over_scene()
		if body.get_collider() is goal:
			go_to_you_win_scene()
			

func go_to_game_over_scene():
	get_tree().change_scene_to_file("res://liquid/game_over.tscn")
	
func go_to_you_win_scene():
	get_tree().change_scene_to_file("res://liquid/you_win.tscn")




# func _on_animated_sprite_2d_animation_finished():
# 	$AnimatedSprite2D.frame = $AnimatedSprite2D.frames.get_frame_count()
