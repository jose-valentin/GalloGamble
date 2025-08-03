extends Sprite2D
var overlapping_sensors := []

@onready var egg = get_node("../Egg")
@onready var wall = get_node("Wall")  # Change this to the actual path to the wall node

var spinning := false
var angular_velocity := 0.0
var friction := 0.99  # Closer to 1 = slower decay (longer spin)
var min_speed := 0.05

func _process(delta):
	if spinning:
		rotation += angular_velocity * delta
		angular_velocity *= friction  # simpler decay formula
		if angular_velocity <= min_speed:
			angular_velocity = 0
			spinning = false
func start_spin():
	if spinning:
		return  # don't restart mid-spin
	spinning = true
	angular_velocity = randf_range(8.0, 15.0)  # These values feel better with decay
	
func _on_SpinButton_pressed():
	if spinning:
		return

	# Reset state if playing again
	if not wall:
		var WallScene = preload("res://scene/wall.tscn")
		wall = WallScene.instantiate()
		get_node(".").add_child(wall)
		wall.position = Vector2(0, 0)  # adjust to match original wall position
	else:
		wall.visible = true

	# Start spinning
	start_spin()

	# Make wall disappear after a delay
	await get_tree().create_timer(1).timeout
	move_wall_out()
func move_wall_out():
	var tween = create_tween()
	tween.tween_property($Wall, "position", $Wall.position + Vector2(0, -300), 1.0)  # Move up over 1 second
	await get_tree().create_timer(1.2).timeout
	wall.queue_free()
	wall = null
	#if wall:  start diggin in yo butt twin

func _ready():
	for i in range(37):
		var detector_name = "numbdetector" + str(i)
		if has_node(detector_name):
			var detector = get_node(detector_name)
			detector.body_entered.connect(_on_detector_body_entered.bind(i))
			detector.body_exited.connect(_on_detector_body_exited.bind(i))
func _on_detector_body_entered(body: Node, index: int):
	if body.name == "Egg":
		if index not in overlapping_sensors:
			overlapping_sensors.append(index)
		_check_current_sensor()
func _on_detector_body_exited(body: Node, index: int):
	if body.name == "Egg":
		if index in overlapping_sensors:
			overlapping_sensors.erase(index)
		_check_current_sensor()
func _check_current_sensor():
	if overlapping_sensors.size() == 0:
		return

	var egg_position = egg.global_position
	var closest_index = -1
	var closest_distance = INF

	for index in overlapping_sensors:
		var detector = get_node("numbdetector" + str(index))
		var distance = egg_position.distance_to(detector.global_position)
		if distance < closest_distance:
			closest_distance = distance
			closest_index = index

	if closest_index != -1:
		print("Egg is currently in sensor:", closest_index)
