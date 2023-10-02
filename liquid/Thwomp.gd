extends RigidBody2D

# Variables
var is_falling: bool = false
var start_position: Vector2
var delay_before_rise: float = 0.2  # seconds

# Called when the node enters the scene tree for the first time.
func _ready():
	start_position = position
	gravity_scale = 0  # Initially, it won't fall
	angular_damp = 1000
	$RayCast2D.enabled = true

# Called every frame.
func _process(delta):
	## keep at no rotation
	#rotation = 0
  # Check if the raycast is colliding with the player
	if $RayCast2D.is_colliding():
		## if not null
		if $RayCast2D.get_collider() != null:
			## if player
			if $RayCast2D.get_collider().is_in_group("player") and not is_falling:
				start_fall()

# Start the Thwomp's descent
func start_fall():
	is_falling = true
	gravity_scale = 1.5  # Start falling

# Called when the Thwomp collides with something
func _on_body_entered(body):
	if is_falling:
		is_falling = false
		gravity_scale = 0  # Stop falling
		# Wait for a delay before rising
		$AudioStreamPlayer2D2.play()
		await get_tree().create_timer(delay_before_rise).timeout
		start_rise()

# Move the Thwomp back to its starting position
func start_rise():
	while position.y > start_position.y:
		position.y -= 10  # Adjust this value for rising speed
		await get_tree().create_timer(0.01).timeout
	position = start_position
