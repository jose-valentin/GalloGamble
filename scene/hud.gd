extends CanvasLayer
signal new_game; 
signal enemy_choice
signal player_choice(choice)
var flag_winner = false
var flag_key = false

func _process(delta: float) -> void:
	if (flag_winner != true and !flag_key) :
		if Input.is_action_just_pressed("Paper"):
			enemy_choice.emit()
			player_choice.emit("paper")
			!flag_key 
		elif Input.is_action_just_pressed("Rock"):
			enemy_choice.emit()
			player_choice.emit("rock")
			!flag_key 
		elif Input.is_action_just_pressed("Scissor"):
			enemy_choice.emit()
			player_choice.emit("scissor")
			!flag_key 
	else: 
		#$Key_text.text = "E                           Q"
		#$Key_text.show()
		if Input.is_action_just_pressed("Try"):
			new_game.emit()
			$Key_text.hide()
		elif Input.is_action_just_pressed("Menu"):
			_on_menu_pressed()
			$Key_text.hide()
		
	
func _on_rock_pressed() -> void:
	enemy_choice.emit()
	player_choice.emit("rock")

func _on_paper_pressed() -> void:
	enemy_choice.emit()
	player_choice.emit("paper")
	
func _on_scissor_pressed() -> void:
	enemy_choice.emit()
	player_choice.emit("scissor")
	
func _on_play_again_pressed() -> void:
	new_game.emit()

func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/MainScene.tscn")

func score_update(score, winner):
	if(winner == "player"):
		$player_points.text = str(score)
	else:
		$enemy_points.text = str(score)
	if(score == 2):
		flag_winner = true

func _on_timer_timeout() -> void:
	$winner_text.hide()
	flag_key = true
	
	

func  show_winner(message):
	$winner_text.text =  message
	$winner_text.show()
	$Timer.start()
	
func  show_keys():
	$Key_text.text = "A                   S                  D"
	#$Key_text.position = Vector2(174, 483)

func show_RPS():
	$Rock.show()
	$Scissor.show()
	$Paper.show()
	show_keys()
	key_restart()

func key_restart():
	flag_winner = false
	
