extends RigidBody2D


# Constants
const GRAVITY = Vector2(0, 980)  # Gravity force vector
const HORIZONTAL_SPEED = 50  # Max horizontal movement speed

# Properties
var velocity = Vector2()  # Current velocity of the gravel
var horizontal_move = 0  # Direction of horizontal movement: -1 for left, 1 for right

func _ready():
	# Set process to true to enable _process function
	self.process = true
	
func _process(delta):
	# Apply gravity
	velocity += GRAVITY * delta
	
	# Apply stochastic horizontal movement
	if randf() < 0.01:  # 1% chance per frame to change direction
		horizontal_move = rand_range(-1, 1)  # Randomly choose -1, 0, or 1
	
	# Move horizontally if not colliding
	var horizontal_velocity = Vector2(horizontal_move * HORIZONTAL_SPEED, 0)
	if not is_colliding_horizontally():
		velocity.x = horizontal_velocity.x
	
	# Move and slide to apply the final velocity, reset horizontal velocity for next frame
	move_and_slide(velocity, Vector2.UP)
	velocity.x = 0

# Check for horizontal collisions
func is_colliding_horizontally() -> bool:
	# Assuming a collision shape of 20 units width, adjust as per your actual size
	# Check both left and right side for collisions
	return get_world_2d().direct_space_state.intersect_ray(global_position + Vector2(-10, 0), global_position + Vector2(-15, 0)) or \
		   get_world_2d().direct_space_state.intersect_ray(global_position + Vector2(10, 0), global
