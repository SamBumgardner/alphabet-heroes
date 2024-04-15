extends VBoxContainer

@export var enemy : Enemy

func _ready():
	enemy.enemy_reinitialized.connect(_on_enemy_reinitialized)
	$TextureRect.texture = enemy.enemy_data.graphic
	$Label.text = enemy.enemy_data.name

func _on_enemy_reinitialized():
	$TextureRect.texture = enemy.enemy_data.graphic
	$Label.text = enemy.enemy_data.name
