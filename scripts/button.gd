extends Button

@onready var label = get_node("../ResultLabel")  # adjust the path if needed

func _on_pressed():
	get_tree().change_scene_to_file("res://scene/BattleScene.tscn")

func _on_Button2_pressed():
	get_tree().change_scene_to_file("res://scene/Arena.tscn")  # to create
func _on_Button3_pressed():
	get_tree().change_scene_to_file("res://scene/eggRoulette.tscn")
func _on_chicken_roshambo_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/chickenRoshambo.tscn")
