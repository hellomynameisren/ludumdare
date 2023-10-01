extends RigidBody2D

var push = 0

func _ready():
	# Set the initial gravity scale to 0 to make it inert
	gravity_scale = 1

func _on_body_entered(body):
    #print("Boulder triggered")
    # Check if the body that entered is in the "player" group
    if body.is_in_group("player"):
        # Determine the direction to apply the impulse based on the player's position
        if push < 3:
            var impulse_direction = Vector2(-500, 0) if body.position.x < position.x else Vector2(500, 0)
            apply_central_impulse(impulse_direction)
            push += 1