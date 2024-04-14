class_name SimpleGameOverHandler extends Node

func _on_gameover_defeat_started(_duration:float):
	print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
	print("   oh no, you have lost!   ")
	print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@")

func _on_gameover_victory_started(_duration:float):
	print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
	print("  congratulation, you win!  ")
	print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@")

func _on_gameover_finished():
	get_tree().quit()
