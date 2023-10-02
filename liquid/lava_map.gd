extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_init_timer_timeout():
	$SpawnTimer.start()


func _on_spawn_timer_timeout():
	pass # Replace with function body.
