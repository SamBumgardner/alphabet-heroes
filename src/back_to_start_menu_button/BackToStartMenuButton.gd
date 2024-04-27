# Shared component to navigate back to the start menu.
extends Control

func _on_exit_button_pressed() -> void:
	Input.set_custom_mouse_cursor(null)
	get_tree().change_scene_to_file("res://src/start_menu/StartMenu.tscn")

func _on_retry_button_pressed() -> void:
	Input.set_custom_mouse_cursor(null)
	get_tree().change_scene_to_file("res://src/gameplay/Gameplay.tscn")
