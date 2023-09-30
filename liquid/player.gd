extends CharacterBody2D

var speed = 200 
var jump_speed = -400
var gravity = 800


func get_input():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if input_vector != Vector2.ZERO:
		velocity.x = input_vector.x * speed
	return input_vector

func _physics_process(delta):
	var input_vector = get_input()
  
	if is_on_floor():
		if Input.is_action_just_pressed("ui_select") and is_on_floor():
			velocity.y = jump_speed
		else:
			velocity.y = 0
	else:
		velocity.y += gravity * delta

	move_and_slide()

	if is_on_wall():
		velocity.x = 0
