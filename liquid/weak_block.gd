extends RigidBody2D

func _ready():
	# Set the initial gravity scale to 0 to make it inert
	gravity_scale = 0

func _on_body_entered(body):
	# print("Body entered")
	# Check if the body that entered is in the "player" group
	if body.is_in_group("player"):
		# Apply an upward impulse
		apply_central_impulse(Vector2(0, -10))
		# Start the delay before enabling gravity
		start_gravity_delay()
	elif body.is_in_group("lava"):
		# If the body is in the "lava" group, remove it
		queue_free()

func start_gravity_delay():
	# Use a Timer to introduce the delay
	var timer = Timer.new()
	timer.wait_time = 0.1
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	add_child(timer)
	timer.start()

func _on_timer_timeout():
	# Set the gravity scale to 1 to make it fall
	gravity_scale = 2
