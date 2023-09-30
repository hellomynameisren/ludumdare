extends CharacterBody2D

# Speed of the platform
var speed = 100

# Direction of movement (-1 for left, 1 for right)
var direction = -1

func _ready():
    # Set the initial velocity
    velocity = Vector2(direction * speed, 0)

func _physics_process(delta):
    # Update the velocity based on direction
    velocity.x = direction * speed
    move_and_slide()

    # Check for collisions on the left or right
    if is_on_wall():
        direction *= -1

func _on_Area2D_body_entered(body):
	# If the player enters the platform, make it a child
    if body.name == "Player":
        body.get_parent().add_child(self)
        body.position = Vector2(0, -16)

func _on_Area2D_body_exited(body):
    # If the player leaves the platform, remove it as a child
    if body.name == "Player":
        body.get_parent().remove_child(self)