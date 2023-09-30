extends Node

# Path to the water block scene
var lava_block_scene = preload("res://liquid/lava_block.tscn")

# Number of blocks to spawn
var number_to_spawn = 10

# Spawn area boundaries (for a 1280x720 screen as an example)
var spawn_min = Vector2(0, 0)
var spawn_max = Vector2(1280, 720)

func _ready():
	for i in range(number_to_spawn):
		spawn_random_lava_block()

func spawn_random_lava_block():
	# Create an instance of the water block
	var block = lava_block_scene.instantiate()
	
	# Set its position to a random location
	block.position = Vector2(
		randf_range(spawn_min.x, spawn_max.x),
		randf_range(spawn_min.y, spawn_max.y)
	)
	
	# Add the block to the current scene
	self.add_child(block)
