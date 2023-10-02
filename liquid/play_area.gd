extends Node2D

class_name play_area


# Preload or load your level scenes (Note: use "preload" if the path is known at compile-time)
# var Level1 = preload("res://liquid/levels/level_one.tscn")
# var Level2 = preload("res://liquid/levels/test_level2.tscn")
# var Level3 = preload("res://liquid/levels/test_level3.tscn")
var levels: Array

# var levels = [Level1, Level2, Level3]


var level_ix = 0

var current_level_scene = null
var current_level = null


# Called when the node enters the scene tree for the first time.
func _ready():
	levels = [
		"res://liquid/complete_levels/01_introduction.tscn",
		"res://liquid/complete_levels/02_climb.tscn",
		"res://liquid/complete_levels/03_crawlers.tscn",
		"res://liquid/levels/gravel_level3.tscn",
		"res://liquid/complete_levels/04_skate.tscn",
		"res://liquid/levels/race_climb.tscn",
		"res://liquid/complete_levels/05_midterm.tscn",
		
		
		#load("res://liquid/levels/chamber_level2.tscn"),
		#load("res://liquid/levels/gravel_level2.tscn"),
		#load("res://liquid/levels/spider_level2.tscn"),
		#load("res://liquid/levels/falling_level.tscn"),
		#load("res://liquid/levels/race_level2.tscn"),
		#preload("res://liquid/levels/gravel_level.tscn"),
		#preload("res://liquid/levels/spider_level.tscn"),
		#preload("res://liquid/levels/test_level.tscn"),
	]
	current_level_scene = load(levels[0])
	reset_level()
	# load_level(Level1)
	
func _input(event):
	if event.is_action_pressed('ui_f9'):
		next_level()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func reset_level():
	load_level(current_level_scene)
	
var did_start_load = false

func start_load_next_level():
	if level_ix < levels.size() - 1:
		var next_scene = levels[level_ix + 1]
		ResourceLoader.load_threaded_request(next_scene)
		did_start_load = true
	

func next_level():
	if level_ix < levels.size() - 1:
		level_ix += 1
		if did_start_load:
			current_level_scene = ResourceLoader.load_threaded_get(levels[level_ix])
		else:
			current_level_scene = load(levels[level_ix])
		did_start_load = false
		reset_level()
	else:
		get_tree().change_scene_to_file("res://liquid/you_win.tscn")
		
func display_level():
	$CanvasLayer.get_node("Label").text = "Level " + str(level_ix + 1)
		
# Function to load a level (accepts a PackedScene as argument)
func load_level(level_scene):
	# If there is a level already, remove it
	if current_level:
		current_level.queue_free()
	
	await get_tree().create_timer(0.15).timeout
	
	# Create an instance of the desired level
	current_level = level_scene.instantiate()
	
	# Add the level instance to the scene tree
	add_child(current_level)
	display_level()
