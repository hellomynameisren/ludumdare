extends StaticBody2D

var gravel_width = 0
var world: Node2D

var timer: Timer

func _ready():
	world = get_parent()
	timer = $Timer
	gravel_width = $CollisionShape2D.shape.extents.x * 2

			
func _is_valid_gravel_position(position: Vector2) -> bool:
	
	# Convert the vector to a string to use it as a key in the dictionary
	# var key = str(position)

	# Check if the result is cached
	# if validity_cache.has(key):
	# 	return validity_cache[key]
		
	var res
	
	var gravel_shape = RectangleShape2D.new()
	gravel_shape.extents = Vector2(gravel_width / 2 * 0.999, gravel_width / 2 * 0.999)  # half extents

	# Check if position is within the world's bounds
	#var top_left = Vector2.ZERO
	#var bottom_right = world.get_node("BottomRight").global_position
	#var world_bounds = Rect2(top_left, bottom_right - top_left)
	
	# Check if the entire lava block would be inside the world bounds
	#var gravel_rect = Rect2(position - gravel_shape.extents, gravel_shape.extents * 2)
	#if not world_bounds.encloses(gravel_rect):
	if false:
		res = false
	else:
		var space_state = PhysicsServer2D.space_get_direct_state(world.get_world_2d().space)
		
		# Set up the shape query
		var query_parameters = PhysicsShapeQueryParameters2D.new()
		query_parameters.shape = gravel_shape
		query_parameters.transform = Transform2D(0, position)
		query_parameters.exclude = [self]

		var collisions = space_state.intersect_shape(query_parameters)
		
		if collisions and collisions.size() > 0:
			res = false  # There's something at this position
		else:
			res = true
	# Cache the result
	# validity_cache[key] = res
	return res



func _on_timer_timeout():
	var potential_positions = []
	for offset in [Vector2(0, 1), Vector2(1, 1), Vector2(-1, 1)]:
		var check_position = self.global_position + gravel_width * offset
		if _is_valid_gravel_position(check_position):
			potential_positions.append(check_position)
	if potential_positions:
		var random_position = potential_positions[randi() % potential_positions.size()]
		position = random_position
	# timer.wait_time += randf_range(0, 0.01)
