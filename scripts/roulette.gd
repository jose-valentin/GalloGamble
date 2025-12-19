extends Sprite2D
@onready var spin_button_animator = get_node("../spinButton/spinButtonAnimator")
@onready var status_label = get_node("/root/Node2D/Label")
var started = false
var result_finalized = false

var overlapping_sensors := []
var selected_bets = {}



#hey
#var bets = { "red": false, "black": false, "even": false, "number": null }
var bets = { # "(1-12)", "(13-24)", "(25-36)"
	"red": false,
	"black": false,
	"even": false,
	"odd": false,
	"high": false,
	"low": false,
	"(1-12)": false,
	"(13-24)": false,
	"(25-36)": false,
	"number": null
}

func _on_bet_button_pressed(bet_type):
	bets[bet_type] = !bets[bet_type]  # Toggle the bet
	print(bet_type.capitalize(), "bet is now", bets[bet_type])
	var button = get_viewport().gui_get_focus_owner()
	if selected_bets.has(bet_type):
		selected_bets.erase(bet_type)
		button.modulate = Color(1, 1, 1)  # Reset color to normal
	else:
		selected_bets[bet_type] = true
		button.modulate = Color(1, 1, 0.5)  # Yellow-ish to show selection

func _on_place_number_bet_pressed():
	var num_selector = get_node("/root/Node2D/betPanel/BettingPanel/NumberSelector")
	bets["number"] = int(num_selector.value)
	print("Betting on number:", bets["number"])






@onready var egg = get_node("../Egg")
@onready var wall = get_node("Wall")  

var spinning := false
var angular_velocity := 0.0
var friction := 0.99  # Closer to 1 = slower decay (longer spin)
var min_speed := 0.05

func _process(delta):
	
	if spinning:
		status_label.text = scramble_text("EGG ROULETTE")
		rotation += angular_velocity * delta
		angular_velocity *= friction  # simpler decay formula
		if angular_velocity <= min_speed:
			angular_velocity = 0
			spinning = false
	if (angular_velocity <= min_speed) and started == true :
		angular_velocity = 0
		spinning = false
			
			# Finalize and show result
		_check_final_result()

func scramble_text(base: String) -> String:
	var allowed_chars = "Egg roulette".replace(" ", "").split("")  # Only letters from "Egg roulette"
	var chars = base.split("")  # Turn base string into array of characters

	for i in chars.size():
		if randf() < 0.6 and chars[i] != " ":
			var random_index = randi() % allowed_chars.size()
			chars[i] = allowed_chars[random_index]

	# Join characters back into a string, then limit to 12 characters
	return "".join(chars).substr(0, "Egg roulette".length())


func _check_final_result():
	if overlapping_sensors.size() == 0:
		status_label.text = "No result"
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

	if closest_index != -1 and result_finalized == false:
		var won = evaluate_bet_result(closest_index)
		status_label.text = "You " + ("won!" if won else "lost!") + " (" + str(closest_index) + ")"
		result_finalized = true  # Prevent changes until next spin

func evaluate_bet_result(number: int) -> bool:
	if bets["number"] != null and bets["number"] == number:
		return true
	if bets["even"] and number % 2 == 0:
		return true
	if bets["odd"] and number % 2 == 1:
		return true
	if bets["low"] and number >= 1 and number <= 18:
		return true
	if bets["high"] and number >= 19 and number <= 36:
		return true
	if bets["(1-12)"] and number >= 1 and number <= 12:
		return true
	if bets["(13-24)"] and number >= 13 and number <= 24:
		return true
	if bets["(25-36)"] and number >= 25 and number <= 36:
		return true
	if bets["red"] and is_red(number):
		return true
	if bets["black"] and is_black(number):
		return true
	return false

func is_red(number: int) -> bool:
	var red_numbers = [1,3,5,7,9,12,14,16,18,19,21,23,25,27,30,32,34,36]
	return number in red_numbers

func is_black(number: int) -> bool:
	var black_numbers = [2,4,6,8,10,11,13,15,17,20,22,24,26,28,29,31,33,35]
	return number in black_numbers


func start_spin():
	started = true
	result_finalized = false  # Reset result when new spin starts
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
	spin_button_animator.play("FlipSwitch")

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
	get_node("/root/Node2D/spinButton").position = Vector2(296, 309)
	for i in range(37):
		var detector_name = "numbdetector" + str(i)
		if has_node(detector_name):
			var detector = get_node(detector_name)
			detector.body_entered.connect(_on_detector_body_entered.bind(i))
			detector.body_exited.connect(_on_detector_body_exited.bind(i))
	create_betting_interface()
	
	
func create_betting_interface():
	var betting_panel = Control.new()
	betting_panel.name = "BettingPanel"
	#betting_panel.size = Vector2(3, 1)  # Full width, smaller height
	betting_panel.position = Vector2(0, 0) 
	get_node("/root/Node2D/betPanel").add_child(betting_panel)

	var y_offset = 10
	var button_spacing = 60

	# Row 1: Red / Black / Even / Odd
	var bet_types = ["Red", "Black", "Even", "Odd"]
	for i in range(bet_types.size()):
		var btn = Button.new()
		btn.text = bet_types[i]
		btn.position = Vector2(10 + i * button_spacing, y_offset)
		btn.pressed.connect(_on_bet_button_pressed.bind(bet_types[i].to_lower()))
		betting_panel.add_child(btn)

	# Row 2: High / Low / Dozen1 / Dozen2 / Dozen3
	y_offset += 40
	var advanced_bet_types = ["High", "Low", "(1-12)", "(13-24)", "(25-36)"]
	for i in range(advanced_bet_types.size()):
		var btn = Button.new()
		btn.text = advanced_bet_types[i]
		btn.position = Vector2(i * 67, y_offset)
		btn.pressed.connect(_on_bet_button_pressed.bind(advanced_bet_types[i].to_lower()))
		betting_panel.add_child(btn)

	# Row 3: Single Number SpinBox + Place Number Bet Button
	y_offset += 40
	var number_label = Label.new()
	number_label.text = "Number:"
	number_label.position = Vector2(10, y_offset + 5)
	betting_panel.add_child(number_label)

	var number_selector = SpinBox.new()
	number_selector.name = "NumberSelector"
	number_selector.min_value = 0
	number_selector.max_value = 36
	number_selector.step = 1
	number_selector.position = Vector2(80, y_offset)
	#number_selector.custom_minimum_size = Vector2(10, 10)  # Make it smaller
	betting_panel.add_child(number_selector)

	var place_number_bet = Button.new()
	place_number_bet.text = "Bet Number"
	place_number_bet.position = Vector2(170, y_offset)
	place_number_bet.pressed.connect(_on_place_number_bet_pressed)
	betting_panel.add_child(place_number_bet)
	# High/Low Buttons, Dozens, Columns — Add similarly

	
	
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
	if overlapping_sensors.size() == 0 or result_finalized:
		return  # Don't check anything if spin result is finalized

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
		# _check_bets(closest_index) -- You can remove this or keep it for visuals, but NOT for status_label updates
		
func _check_bets(number):
	var is_red = [1,3,5,7,9,12,14,16,18,19,21,23,25,27,30,32,34,36].has(number)
	var is_black = [2,4,6,8,10,11,13,15,17,20,22,24,26,28,29,31,33,35].has(number)
	var is_even = number % 2 == 0 and number != 0
	var is_odd = number % 2 != 0

	if bets["red"] and is_red:
		print(" You won on Red!")
	if bets["black"] and is_black:
		print(" You won on Black!")
	if bets["even"] and is_even:
		print(" You won on Even!")
	if bets["odd"] and is_odd:
		print(" You won on Odd!")
	if bets["high"] and number >= 19 and number <= 36:
		print(" You won on High!")
	if bets["low"] and number >= 1 and number <= 18:
		print(" You won on Low!") # # "(1-12)", "(13-24)", "(25-36)"
	if bets["(1-12)"] and number >= 1 and number <= 12:
		print(" You won on Dozen 1!")
	if bets["(13-24)"] and number >= 13 and number <= 24:
		print(" You won on Dozen 2!")
	if bets["(25-36)"] and number >= 25 and number <= 36:
		print(" You won on Dozen 3!")
	if bets["number"] != null and bets["number"] == number:
		print(" You hit the exact number!")
		
func _on_mainMenuPressed():
	get_tree().change_scene_to_file("res://scene/MainScene.tscn")
