extends VBoxContainer

@export var enemy : Enemy

func _ready():
	$TextureRect.texture = enemy.enemy_data.graphic
	$Label.text = enemy.enemy_data.name
