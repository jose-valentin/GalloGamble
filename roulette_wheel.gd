extends Sprite2D

var spinning := false
var angular_velocity := 0.0
var friction := 30.0  # Adjust to slow the spin over time

func _process(delta):
	if spinning:
		rotation += angular_velocity * delta
		angular_velocity = max(angular_velocity - friction * delta, 0.0)
		if angular_velocity <= 0:
			spinning = false
			print("Spin finished! Final angle:", rotation)
			determine_result()

func start_spin():
	spinning = true
	angular_velocity = randf_range(6.0, 10.0)  # Random initial spin speed

func determine_result():
	var final_angle = fmod(rotation, TAU)
	var segment = int(final_angle / (TAU / 37))  # 37 segments: 0-36
	print("Landed on number:", segment)
func _on_SpinButton_pressed():
	start_spin()
