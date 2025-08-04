extends CanvasLayer
signal new_game; 
signal enemy_choice
signal player_choice(choice)


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

func _on_timer_timeout() -> void:
	$winner_text.hide()
	
func  show_winner(message):
	$winner_text.text =  message
	$winner_text.show()
	$Timer.start()
	
	
