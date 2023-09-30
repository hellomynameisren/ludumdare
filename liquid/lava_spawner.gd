extends Node


# Path to the water block scene
var lava_block_scene = preload("res://liquid/lava_block.tscn")
var lava_width = 8


# Adjust these as per your game's needs
var LAVA_TILE_ID = 1  # ID of your lava tile
var CHECK_INTERVAL = 1.0  # seconds

var world: Node2D

# Number of blocks to spawn
var number_to_spawn = 10

# Spawn area boundaries (for a 1280x720 screen as an example)
var spawn_min = Vector2(0, 0)
var spawn_max = Vector2(1280, 720)

func _ready():
	world = get_parent()
	set_process(true)

func _process(delta):
	pass
	

# Assuming you have a Lava scene or Lava script, you'll load it for instantiation
var LavaScene = preload("res://liquid/lava_block.tscn")

func _add_lava():
	var potential_positions = []

	for child in world.get_children():
		# Check if the child is a lava node, adjust this based on your setup
		if child is lava_block:  # Or "child is Lava" if Lava is a script type
			for offset in [Vector2(0, 1), Vector2(1, 0), Vector2(0, -1), Vector2(-1, 0)]:
				var check_position = child.global_position + lava_width * offset
				if _is_valid_lava_position(check_position):
					potential_positions.append(check_position)
					

	if potential_positions:
		# Filter to only the positions with the highest y value
		var highest_y = potential_positions[0].y
		for pos in potential_positions:
			highest_y = max(highest_y, pos.y)
			
		var highest_y_positions = []
		for pos in potential_positions:
			if pos.y == highest_y:
				highest_y_positions.append(pos)
				
		print("Highest y positions: " + str(highest_y_positions))
		var random_position = highest_y_positions[randi() % highest_y_positions.size()]
		_place_lava_at(random_position)
		

func _place_lava_at(position: Vector2):
	var lava_instance = LavaScene.instantiate()
	lava_instance.global_position = position
	world.add_child(lava_instance)
	
func _is_valid_lava_position(position: Vector2) -> bool:
	
	var lava_shape = RectangleShape2D.new()
	lava_shape.extents = Vector2(lava_width / 2 * 0.999, lava_width / 2 * 0.999)  # half extents

	# Check if position is within the world's bounds
	var top_left = Vector2.ZERO
	var bottom_right = world.get_node("BottomRight").global_position
	var world_bounds = Rect2(top_left, bottom_right - top_left)
	
	# Check if the entire lava block would be inside the world bounds
	var lava_rect = Rect2(position - lava_shape.extents, lava_shape.extents * 2)
	if not world_bounds.encloses(lava_rect):
		return false
	
	print("got fast first check: "+ str(position))
		
	var space_state = PhysicsServer2D.space_get_direct_state(world.get_world_2d().space)
	
	# Set up the shape query
	var query_parameters = PhysicsShapeQueryParameters2D.new()
	query_parameters.shape = lava_shape
	query_parameters.transform = Transform2D(0, position)
	query_parameters.exclude = [self]

	var collisions = space_state.intersect_shape(query_parameters)
	
	if collisions and collisions.size() > 0:
		return false  # There's something at this position

	# No collisions, the position is valid
	return true


func _on_timer_timeout():
	_add_lava()
