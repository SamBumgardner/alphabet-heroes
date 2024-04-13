extends Control

@onready var database = get_node("/root/Database")

func _ready():
	database.reset_values()

func _process(delta):
	pass
