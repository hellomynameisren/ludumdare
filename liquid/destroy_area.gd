extends Area2D

class_name destroy_area


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func destroy_in_area():
	for body in get_overlapping_bodies():
		if body is breakable_wall:
			body.queue_free()