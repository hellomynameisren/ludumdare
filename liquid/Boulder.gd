extends RigidBody2D

var push = 0
var pushes = 1
var speed = 600
var winertia = 265

func _ready():
	# Set the initial gravity scale to 0 to make it inert
	gravity_scale = 1

func _on_body_entered(body):
	#print("Boulder triggered")
	# Check if the body that entered is in the "player" group
	if body.is_in_group("player"):
		# Determine the direction to apply the impulse based on the player's position
		if push < pushes:
			var impulse_direction = Vector2(-speed, 0) if body.position.x < position.x else Vector2(speed, 0)
			apply_central_impulse(impulse_direction)
			push += 1
			speed *= 2
		else:
			var impulse_direction = Vector2(-winertia, 0) if body.position.x < position.x else Vector2(winertia, 0)
			apply_central_impulse(impulse_direction)
