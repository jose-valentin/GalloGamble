extends CanvasLayer
signal new_game; 
signal enemy_choice
signal player_choice(choice)


func _on_rock_pressed() -> void:
	player_choice.emit("rock")
	enemy_choice.emit()

func _on_paper_pressed() -> void:
	player_choice.emit("paper")
	enemy_choice.emit()

func _on_scissor_pressed() -> void:
	player_choice.emit("scissor")
	enemy_choice.emit()

func _on_play_again_pressed() -> void:
	new_game.emit()
