extends Node2D

@onready var rooster_a = $RoosterA
@onready var rooster_b = $RoosterB
@onready var result_label = $ResultLabel
@onready var start_button = $StartButton
@onready var terrain = $Terrain  # Adjust path if needed
var winner = ""
var winCheck = false


func _ready():
	# Optional but helps enforce stillness
	rooster_a.linear_velocity = Vector2.ZERO
	rooster_a.angular_velocity = 0.0
	rooster_b.linear_velocity = Vector2.ZERO
	rooster_b.angular_velocity = 0.0

	# Initially disable movement
	rooster_a.gravity_scale = 0
	rooster_b.gravity_scale = 0
	rooster_a.sleeping = true
	rooster_b.sleeping = true

	# Get Terrain's position and size
	var tex_size = terrain.texture.get_size() * terrain.scale
	var top_left = terrain.global_position - (tex_size / 2)
	var margin = 50

	# Rooster A on left half
	rooster_a.global_position = Vector2(
		randf_range(top_left.x + margin, top_left.x + tex_size.x / 2 - margin),
		randf_range(top_left.y + margin, top_left.y + tex_size.y - margin)
	)

	# Rooster B on right half
	rooster_b.global_position = Vector2(
		randf_range(top_left.x + tex_size.x / 2 + margin, top_left.x + tex_size.x - margin),
		randf_range(top_left.y + margin, top_left.y + tex_size.y - margin)
	)

	start_button.pressed.connect(_on_StartButton_pressed)

	var sprite_a = rooster_a.get_node("Sprite2D")  # adjust name if needed
	var texture_size_a = sprite_a.texture.get_size() * sprite_a.scale
	print("Rooster A texture size (after scale): ", texture_size_a)
	print("Rooster A global scale: ", rooster_a.global_scale)

func _on_StartButton_pressed():
	rooster_a.gravity_scale = 1
	rooster_b.gravity_scale = 1

	start_button.disabled = true
	start_button.hide()

	rooster_a.sleeping = false
	rooster_b.sleeping = false

	start_fight()

func start_fight():
	print("Starting fight!")
	var direction = (rooster_b.position - rooster_a.position).normalized()

	# Apply opposing impulses
	var impulse_strength = 300
	rooster_a.apply_impulse(direction * impulse_strength)
	rooster_b.apply_impulse(-direction * impulse_strength)

	# Randomized spin
	rooster_a.angular_velocity = 200
	rooster_b.angular_velocity = 200

var fight_timer := 0.0
var check_interval := 1.0
var max_angular_velocityA = 200.0
var max_angular_velocityB = 200.0

func _physics_process(delta):
	if !winCheck:
		rooster_a.angular_velocity = max_angular_velocityA
		rooster_b.angular_velocity = -max_angular_velocityB


	var angular_damp_factor = 0.0599

	# Dampen angular velocity a bit each frame
	for rooster in [rooster_a, rooster_b]:
		if winCheck:
			continue  # Skip damping if we already have a winner

		max_angular_velocityA -= angular_damp_factor
		max_angular_velocityB -= angular_damp_factor

		# Clamp angular velocity
		if rooster.angular_velocity > max_angular_velocityA:
			rooster.angular_velocity = max_angular_velocityA
		elif rooster.angular_velocity < -max_angular_velocityB:
			rooster.angular_velocity = -max_angular_velocityB


	# Slowly reduce angular velocity
	#rooster_a.angular_velocity -= 1
	#rooster_b.angular_velocity -= 1

	if start_button.disabled:
		fight_timer += delta
		if fight_timer >= check_interval:
			fight_timer = 0.0
			check_if_stopped()

	# Slow down if near center
	var center = terrain.global_position
	for rooster in [rooster_a, rooster_b]:
		if (rooster.global_position - center).length() < 60:
			rooster.linear_velocity *= 0.98

	# Push apart if too close
	var dist = (rooster_a.global_position - rooster_b.global_position).length()
	
	if dist < 30:
		print(dist)
#		var push_dir = (rooster_a.global_position - rooster_b.global_position).normalized()
#		var bounce_force = rooster_a.linear_velocity + rooster_b.linear_velocity
#		rooster_a.apply_central_impulse(push_dir * bounce_force)
#		rooster_b.apply_central_impulse(-push_dir * bounce_force)

	# Apply random angular velocity changes (damping or boosting)
		var ang_adjust_a = randf_range(-1, 30)  # mostly dampens spin
		max_angular_velocityA -= ang_adjust_a
		check_if_stopped()
		var ang_adjust_b = randf_range(-1, 30)  # mostly dampens spin
		max_angular_velocityB -= ang_adjust_b
		check_if_stopped()

	# Add spin (reduced amount)
#	var spin_boost = 1
##	rooster_a.angular_velocity += spin_boost
#	rooster_b.angular_velocity -= spin_boost

func check_if_stopped():
	if winCheck == true: $PlayAgainButton.show()
	var speed_a = rooster_a.linear_velocity.length()
	var speed_b = rooster_b.linear_velocity.length()
	var ang_a = rooster_a.angular_velocity
	var ang_b = rooster_b.angular_velocity

	var linear_threshold = 0
	var angular_threshold = 0.001

	var a_stopped = speed_a < linear_threshold or ang_a <= 0.0
	var b_stopped = speed_b < linear_threshold or ang_b >= 0.0

	print("Speed A:", speed_a, " | B:", speed_b)
	print("Angular A:", ang_a, " | B:", ang_b)

	if a_stopped and b_stopped:
		if winCheck == false:
			result_label.text = "🐔 It's a tie!"
		get_tree().paused = true
		winCheck = true
	elif a_stopped:
		if winCheck == false:
			result_label.text = "🐔 Rooster Blue stopped! Loses!"
			max_angular_velocityA = 0
		winCheck = true
		winner = "a"
		rooster_a.linear_velocity = Vector2.ZERO
		rooster_a.angular_velocity = 0.0
		$WinnerStopTimer.start()
	elif b_stopped:
		if winCheck == false:
			result_label.text = "🐔 Rooster Red stopped! Loses!"
			max_angular_velocityB = 0
		winCheck = true
		winner = "b"
		rooster_b.linear_velocity = Vector2.ZERO
		rooster_b.angular_velocity = 0.0
		$WinnerStopTimer.start()
		#test


func _on_WinnerStopTimer_timeout():
	if winner == "a":
		rooster_a.linear_velocity = Vector2.ZERO
		rooster_a.angular_velocity = 0.0
	elif winner == "b":
		rooster_b.linear_velocity = Vector2.ZERO
		rooster_b.angular_velocity = 0.0
	$PlayAgainButton.show()


func _on_PlayAgainButton_pressed():
	get_tree().change_scene_to_file("res://MainScene.tscn")
