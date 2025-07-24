extends Node2D
@onready var rooster_a = $Gallo1
@onready var rooster_b = $Gallo2
@onready var label = $ResultLabel

func _ready():
	# Wait for player to bet
	label.text = "Choose your bet!"

func _on_BetOnAButton_pressed():
	Global.bet_on = 0
	Global.current_bet = 10  # or let the player choose later
	Global.subtract_money(Global.current_bet)
	label.text = "You bet on Rooster A!"
	start_fight()

func _on_BetOnBButton_pressed():
	Global.bet_on = 1
	Global.current_bet = 10
	Global.subtract_money(Global.current_bet)
	label.text = "You bet on Rooster B!"
	start_fight()

func start_fight():
	var winner = randi() % 2
	await get_tree().create_timer(1.2).timeout

	if winner == 0:
		label.text = "🐔 Rooster A wins!"
		animate_rooster(rooster_a, rooster_b)
	else:
		label.text = "🐔 Rooster B wins!"
		animate_rooster(rooster_b, rooster_a)

	# Payout
	if Global.bet_on == winner:
		Global.add_money(Global.current_bet * 2)
		label.text += "\nYou won the bet!"
	else:
		label.text += "\nYou lost the bet!"

func animate_rooster(attacker: Node2D, target: Node2D):
	var original_position = attacker.position
	var direction = (target.position - attacker.position).normalized()
	var attack_distance = 50
	var repeat_count = 3
	var delay = 0.2

	for i in range(repeat_count):
		attacker.position += direction * attack_distance
		await get_tree().create_timer(delay).timeout
		attacker.position = original_position
		await get_tree().create_timer(delay).timeout

func _on_BackButton_pressed():
	get_tree().change_scene_to_file("res://MainScene.tscn")
