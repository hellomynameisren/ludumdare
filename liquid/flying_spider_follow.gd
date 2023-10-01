extends PathFollow2D

# Set the speed in pixels per second.
var speed: float = 100.0  

func _process(delta: float) -> void:
	# var path_length = get_parent().get_path_length()
	var movement_per_frame = (speed * delta) 
	
	# Update the offset.
	progress += movement_per_frame
