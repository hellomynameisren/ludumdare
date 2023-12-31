extends StaticBody2D

class_name lava_block

var world: Node2D
var lava_width = 0
var exhausted = false

# Called when the node enters the scene tree for the first time.
func _ready():
	world = get_parent()
	lava_width = $CollisionShape2D.shape.extents.x * 2


var reset_timer: Timer

var bad_offsets = []
	
func get_valid_lava_neighbors() -> Array:
	if exhausted:
		return []
	var potential_positions = []
	for offset in [Vector2(0, 1), Vector2(1, 0), Vector2(0, -1), Vector2(-1, 0)]:
		if not bad_offsets.has(offset):
			var check_position = self.global_position + lava_width * offset
			if _is_valid_lava_position(check_position):
				potential_positions.append(check_position)
			else:
				bad_offsets.append(offset)
	if not potential_positions:
		exhausted = true
		$CPUParticles2D.emitting = false
		reset_timer = Timer.new()  # Create a new Timer instance
		self.add_child(reset_timer)  # Add it as a child to ensure it ticks
		reset_timer.wait_time = 0.5 + randf_range(0, 0.1)  # Set the time to wait
		reset_timer.one_shot = true  # Make sure it only ticks once
		reset_timer.start()  # Start the timer
		
		# Connect its timeout signal to a lambda function that resets 'exhausted'
		reset_timer.connect("timeout", self._on_reset_timer_timeout)
	return potential_positions

func _on_reset_timer_timeout():
	exhausted = false
	reset_timer.queue_free()
	bad_offsets = []
	

func _is_valid_lava_position(position: Vector2) -> bool:
	
	# Convert the vector to a string to use it as a key in the dictionary
	# var key = str(position)

	# Check if the result is cached
	# if validity_cache.has(key):
	# 	return validity_cache[key]
		
	var res
	
	var lava_shape = RectangleShape2D.new()
	lava_shape.extents = Vector2(lava_width / 2 * 0.999, lava_width / 2 * 0.999)  # half extents

	# Check if position is within the world's bounds
	#var top_left = Vector2(-400, -400)
	#var bottom_right = world.get_node("BottomRight").global_position
	#var world_bounds = Rect2(top_left, bottom_right - top_left)
	
	# Check if the entire lava block would be inside the world bounds
	var lava_rect = Rect2(position - lava_shape.extents, lava_shape.extents * 2)
	var space_state = PhysicsServer2D.space_get_direct_state(world.get_world_2d().space)
	
	# Set up the shape query
	var query_parameters = PhysicsShapeQueryParameters2D.new()
	query_parameters.shape = lava_shape
	query_parameters.transform = Transform2D(0, position)
	query_parameters.exclude = [self, world.get_node("Player")]

	var collisions = space_state.intersect_shape(query_parameters)
	
	if collisions and collisions.size() > 0:
		res = false  # There's something at this position
	else:
		res = true
	# Cache the result
	# validity_cache[key] = res
	return res
