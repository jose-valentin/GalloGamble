extends RigidBody2D

const GRAVITY = 500  # Adjust to your liking (pixels/sec^2)

func _physics_process(delta):
	if not sleeping:
		apply_force(Vector2(0, GRAVITY * mass))
	
func push_left():
	sleeping = false
	var force = Vector2(-200, -100)  # Push left, adjust magnitude as needed
	print("applyinggg")
	apply_impulse(Vector2.ZERO, force)
	
