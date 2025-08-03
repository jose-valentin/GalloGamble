extends Node2D
var score_player
var score_enemy
var player_choice
var enemy_choice


func new_game():
	score_player = 0
	score_enemy = 0

func game_over():
	if(player_choice == enemy_choice):
		print("tie",player_choice,enemy_choice)
	elif (player_choice == "rock" and enemy_choice == "scissor"):
		print("You got a point",player_choice,enemy_choice)
	elif (player_choice == "rock" and enemy_choice == "paper"):
		print("Your enemy got a point",player_choice,enemy_choice)
	elif (player_choice == "paper" and enemy_choice == "scissor"):
		print("Your enemy got a point",player_choice,enemy_choice)
	elif (player_choice == "paper" and enemy_choice == "rock"):
		print("You got a point",player_choice,enemy_choice)
	elif (player_choice == "scissor" and enemy_choice == "rock"):
		print("Your enemy got a point",player_choice,enemy_choice)
	elif (player_choice == "scissor" and enemy_choice == "paper"):
		print("You got a point", player_choice, enemy_choice)
	
	
func check_score():
	if score_player == 2:
		print("You WIN!")
	elif (score_enemy == 2):
		print('You Lost :(')
		 
	
func _on_hud_new_game() -> void:
	new_game()

func _on_hud_enemy_choice() -> void:
	enemy_choice = ["rock","paper","scissor"].pick_random()


func _on_hud_player_choice(choice: Variant) -> void:
	player_choice = choice
	game_over()
