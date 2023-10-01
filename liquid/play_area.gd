extends Node2D


# Preload or load your level scenes (Note: use "preload" if the path is known at compile-time)
var Level1 = preload("res://liquid/levels/level_one.tscn")
var Level2 = preload("res://liquid/levels/test_level2.tscn")
var Level3 = preload("res://liquid/levels/test_level3.tscn")

var levels = [Level1, Level2, Level3]

var level_ix = 0

var current_level = null


# Called when the node enters the scene tree for the first time.
func _ready():
	load_level(Level1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
# Function to load a level (accepts a PackedScene as argument)
func load_level(level_scene):
	# If there is a level already, remove it
	if current_level:
		current_level.queue_free()
	
	# Create an instance of the desired level
	current_level = level_scene.instantiate()
	
	# Add the level instance to the scene tree
	add_child(current_level)
