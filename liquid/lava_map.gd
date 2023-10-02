extends Node2D

@export var spawn_per_iter = 20
@export var chunk = 2

var lava_emitter_scene = preload("res://liquid/lava_emitter.tscn")


var adjacent_positions = {}

# var y_to_adjacent_xs = {}

var lava_width = 16

var world

var lava_emitters = {}

var global_pq: Array = []

func pq_key(val: Vector2):
	return val.y

func pq_ix_parent(i: int):
	return floor(i/2)
	
func pq_ix_left(i: int):
	return i*2
	
func pq_ix_right(i: int):
	return i*2 + 1
	
func pq_new():
	return [null]
	
func pq_swap(pq: Array, i: int, j: int):
	var tmp = pq[i]
	pq[i] = pq[j]
	pq[j] = tmp

func pq_insert(pq: Array, val):
	pq.append(val)
	var i = pq.size() - 1
	while i != 1 and pq_key(pq[i]) > pq_key(pq[pq_ix_parent(i)]):
		pq_swap(pq, i, pq_ix_parent(i))
		i = pq_ix_parent(i)
		
func pq_size(pq: Array):
	return pq.size() - 1
	
func pq_max(pq: Array):
	if pq.size() == 1:
		assert(false)
	return pq[1]
	
func pq_extract_max(pq: Array):
	if pq.size() == 1:
		assert(false)
	if pq.size() == 2:
		return pq.pop_back()
	var root = pq[1]
	pq[1] = pq.pop_back()
	var i = 1
	while true:
		var l = pq_ix_left(i)
		var r = pq_ix_right(i)
		var largest = i
		if l < pq.size() and pq_key(pq[l]) > pq_key(pq[i]):
			largest = l
		if r < pq.size() and pq_key(pq[r]) > pq_key(pq[largest]):
			largest = r
		if largest == i:
			break
		pq_swap(pq, i, largest)
		i = largest
	return root
		



func add_adjacent(loc: Vector2) -> bool:
	var res = not adjacent_positions.has(loc)
	adjacent_positions[loc] = true
	return res
	
func remove_adjacent(loc: Vector2):
	adjacent_positions.erase(loc)
	
func check_emitter(loc: Vector2):
	return
	print("check_emitter " + str(loc))
	var is_surrounded = true
	for offset in [Vector2(0, 1), Vector2(0, -1), Vector2(1, 0), Vector2(-1, 0)]:
		var loc2 = loc + offset
		if $TileMap.get_cell_source_id(0, loc2) != 0:
			is_surrounded = false
			break
	if is_surrounded:
		if not lava_emitters.has(loc):
			var emitter = lava_emitter_scene.instantiate()
			lava_emitters[loc] = emitter
			var global_pos = to_global_position(loc)
			emitter.global_position = global_pos
			add_child(emitter)
			emitter.global_position = global_pos
	if not is_surrounded:
		if lava_emitters.has(loc):
			lava_emitters[loc].queue_free()
			lava_emitters.erase(loc)
			
func put_lava_at(loc: Vector2) -> Array:
	var new_neighbors = []
	$TileMap.set_cell(0, loc, 0, Vector2(0, 0))
	remove_adjacent(loc)
	check_emitter(loc)
	for offset in [Vector2(0, 1), Vector2(0, -1), Vector2(1, 0), Vector2(-1, 0)]:
		var loc2 = loc + offset
		check_emitter(loc2)
		if add_adjacent(loc2):
			new_neighbors.append(loc2)
			pq_insert(global_pq, loc2)
	return new_neighbors

# Called when the node enters the scene tree for the first time.
func _ready():
	
	world = get_parent()
	global_pq = pq_new()
	global_position = world.get_node("TileMap").global_position
	
	#var used_rect = $TileMap.get_used_rect()
	#for x in range(used_rect.position.x, used_rect.position.x + used_rect.size.x):
	#	for y in range(used_rect.position.y, used_rect.position.y + used_rect.size.y):
	#		var tile_coord = Vector2(x, y)
	#		var tile_id = $TileMap.get_cell_source_id(0, tile_coord)
	#		if tile_id == 0: # lava
				# put_lava_at(tile_coord)
	#			print("found lava at " + str(tile_coord))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_init_timer_timeout():
	$SpawnTimer.start()


func _on_spawn_timer_timeout():
	place_lava(spawn_per_iter)
		
func place_lava(to_place: int):
	while pq_size(global_pq) > 0:
		var try_pos = pq_extract_max(global_pq)
		if is_valid_lava_pos(try_pos):
			put_lava_at(try_pos)
			to_place -= 1
			if to_place == 0:
				return
	#var pq = pq_new()
	#for pos in adjacent_positions:
	#	if is_valid_lava_pos(pos):
	#		pq_insert(pq, pos)
	#while true:
	#	var lowest = []
	#	while pq_size(pq) > 0:
	#		if lowest.size() == 0 or pq_max(pq).y == lowest[lowest.size()-1].y:
	#			lowest.append(pq_extract_max(pq))
	#		else:
	#			break
	#	if lowest.size() == 0:
	#		return
	#	lowest.shuffle()
	#	while lowest.size() > 0:
	#		var place_at = lowest.pop_back()
	#		for neighbor in put_lava_at(place_at):
	#			if is_valid_lava_pos(neighbor):
	#				pq_insert(pq, neighbor)
	#		to_place -= 1
	#		if to_place == 0:
	#			return
				
func to_global_position(pos: Vector2):
	var local_pos = $TileMap.map_to_local(pos + Vector2(1/2, 1/2))
	return $TileMap.to_global(local_pos)
	
			
func is_valid_lava_pos(tile_coord: Vector2):
	var position = to_global_position(tile_coord)
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

