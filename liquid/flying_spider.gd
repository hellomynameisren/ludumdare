extends StaticBody2D

class_name flying_spider


var previous_x: float  # Store the previous x position.



# Called when the node enters the scene tree for the first time.
func _ready():
	previous_x = global_position.x


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if global_position.x > previous_x:
		$AnimatedSprite2D.flip_h = true  # No flip
	elif global_position.x < previous_x:
		$AnimatedSprite2D.flip_h = false
	previous_x = global_position.x
