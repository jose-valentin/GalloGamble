
extends Node2D

func _on_Button_pressed():
	get_tree().change_scene_to_file("res://BattleScene.tscn")

func _on_Button2_pressed():
	get_tree().change_scene_to_file("res://ArenaScene.tscn")  # to create
