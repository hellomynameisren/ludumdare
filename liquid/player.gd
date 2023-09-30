extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



# Movement speed
var speed = 200  # Pixels per second

func _process(delta):
	# Get the movement direction
	var direction = 0
	if Input.is_action_pressed("ui_right"):
		direction += 1
	if Input.is_action_pressed("ui_left"):
		direction -= 1

	# Calculate the new position
	var velocity = Vector2(direction * speed, 0)
	position += velocity * delta
