extends Sprite2D

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
			determine_result()

func start_spin():
	if spinning:
		return  # don't restart mid-spin
	spinning = true
	angular_velocity = randf_range(8.0, 15.0)  # These values feel better with decay

func determine_result():
	var final_angle = fmod(rotation, TAU)
	var segment = int(final_angle / (TAU / 37))
	print("🎯 Landed on number:", segment)
