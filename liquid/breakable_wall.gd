extends StaticBody2D

class_name breakable_wall

var break_wall_scene = preload("res://liquid/break_wall.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func destroy():
	var right_break = break_wall_scene.instantiate()
	right_break.global_position = global_position + Vector2(16, 0)
	get_parent().add_child(right_break)
	
	var left_break = break_wall_scene.instantiate()
	left_break.global_position = global_position + Vector2(-16, 0)
	left_break.get_node("AnimatedSprite2D").flip_h = true
	get_parent().add_child(left_break)
	
	queue_free()
