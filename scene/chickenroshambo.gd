extends Node2D
var score_player 
var score_enemy 
var player_choice
var enemy_choice

func _ready() -> void:
	score_player= 0
	score_enemy= 0
	$HUD/PlayAgain.hide()
	$HUD/Menu.hide()
	$HUD.score_update(0, "player")
	$HUD.score_update(0, "enemy")
	$HUD.show_RPS()
	$Enemy/AnimatedSprite2D.animation = "enemy_enters"
	$Enemy/AnimatedSprite2D.position = Vector2(190,80)
	$Enemy/AnimatedSprite2D.play()
	
	await $Enemy/AnimatedSprite2D.animation_finished 

	$Enemy/AnimatedSprite2D.animation = "Idle"
	$Enemy/AnimatedSprite2D.position = Vector2(0,0)
	
func game_over():
	$HUD/PlayAgain.show()
	$HUD/Menu.show()
	$HUD/Rock.hide()
	$HUD/Scissor.hide()
	$HUD/Paper.hide()
	
	
func round_played():
	if(player_choice == enemy_choice):
		print("tie"," ",player_choice," ", enemy_choice)
		$HUD.show_winner("draw")
		
	elif (player_choice == "rock" and enemy_choice == "scissor") \
		or (player_choice == "paper" and enemy_choice == "rock") \
		or (player_choice == "scissor" and enemy_choice == "paper"):
		score_player += 1
		$HUD.score_update(score_player, "player")
		$HUD.show_winner("player")
		print("You got a point"," ",player_choice,score_player," ",enemy_choice, " ", score_enemy)
		
		
	elif (player_choice == "rock" and enemy_choice == "paper") \
	or (player_choice == "scissor" and enemy_choice == "rock") \
	or (player_choice == "paper" and enemy_choice == "scissor"):
		score_enemy += 1
		$HUD.score_update(score_enemy, "enemy")
		
		$HUD.show_winner("enemy")
		print("Your enemy got a point",player_choice,enemy_choice)
	
	check_score()

		
func check_score():

	if (score_player == 2):
		print("You WIN! 😎")
		game_over()
	elif (score_enemy == 2):
		print('You Lost 😢')

		$HUD/Key_text.hide()
		$Enemy/AnimatedSprite2D.animation = "enemy_lost"
		$Enemy/AnimatedSprite2D.position = Vector2(190, 80)
		print("You WIN!")
		game_over()
	elif (score_enemy == 2):
		print('You Lost :(')
		$HUD/Key_text.hide()
		$Enemy/AnimatedSprite2D.animation = "enemy_win"
		$Enemy/AnimatedSprite2D.position = Vector2(0,0)
		#$HUD/PlayAgain.position = Vector2(34,416)
		#$HUD/Menu.position = Vector2(212,415)
		game_over()
		 
	
func _on_hud_new_game() -> void:
	_ready()

func _on_hud_enemy_choice() -> void:
	enemy_choice = ["rock","paper","scissor"].pick_random()
	$Enemy/AnimatedSprite2D.animation = enemy_choice
	$Enemy/AnimatedSprite2D.position = Vector2(0,0)
	$Enemy/AnimatedSprite2D.play()

func _on_hud_player_choice(choice: Variant) -> void:
	player_choice = choice
	round_played()

	
