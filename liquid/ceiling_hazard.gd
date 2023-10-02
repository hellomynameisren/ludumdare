extends RigidBody2D

func _ready():
	# Set the initial gravity scale to 0 to make it inert
	gravity_scale = 0

func _on_body_entered(body):
	print("Body entered")
	# Check if the body that entered is in the "player" group
	if body.is_in_group("player"):
		# Apply an upward impulse
		apply_central_impulse(Vector2(0, -10))
		# Set the gravity scale to 1 to make it fall
		gravity_scale = 1
