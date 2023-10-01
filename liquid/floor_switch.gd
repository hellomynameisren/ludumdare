extends Area2D

var depressed = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_body_entered(body):
	if body.is_in_group("player"):
		depressed = true
		$Sprite2D.frame = 1
		for child in get_children():
			if child is destroy_area:
				child.destroy_in_area()

