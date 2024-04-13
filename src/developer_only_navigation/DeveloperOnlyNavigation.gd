extends Control

func _on_win_button_pressed():
	get_tree().change_scene_to_file("res://src/game_over_win/GameOverWin.tscn")

func _on_lose_button_pressed():
	get_tree().change_scene_to_file("res://src/game_over_lose/GameOverLose.tscn")
