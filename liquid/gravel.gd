extends RigidBody2D

# Constants
const HORIZONTAL_SPEED = 50  # Max horizontal movement speed

# Properties
var horizontal_move = 0  # Direction of horizontal movement: -1 for left, 1 for right

func _ready():
	set_process(true)

func _process(delta):
	# Apply stochastic horizontal movement
	if randf() < 0.01:  # 1% chance per frame to change direction
		horizontal_move = randf_range(-1, 1) 

	# Apply impulse if not colliding
	var horizontal_velocity = Vector2(horizontal_move * HORIZONTAL_SPEED, 0)
	if not is_colliding_horizontally():
		apply_central_impulse(horizontal_velocity * mass * delta)

# Check for horizontal collisions
func is_colliding_horizontally() -> bool:
	return false
	# Assuming a collision shape of 20 units width, adjust as per your actual size
	# Check both left and right side for collisions
	# return get_world_2d().direct_space_state.intersect_ray(global_position + Vector2(-10, 0), global_position + Vector2(-15, 0)) \
	#	or get_world_2d().direct_space_state.intersect_ray(global_position + Vector2(10, 0), global_position + Vector2(15, 0))
