extends Control

@onready var database = get_node("/root/Database")

@onready var row_heroes_summoned_count = $PanelContainer/MarginContainer/Rows/HeroesSummoned/Count
@onready var row_monsters_slain_count = $PanelContainer/MarginContainer/Rows/MonstersSlain/Count
@onready var row_peasants_conscripted_count = $PanelContainer/MarginContainer/Rows/PeasantsConscripted/Count
@onready var row_fights_retried_count = $PanelContainer/MarginContainer/Rows/FightsRetried/Count

func _ready():
	_init_statistics_rows_counts()

func _init_statistics_rows_counts() -> void:
	row_heroes_summoned_count.text = str(database.heroes_summoned_count)
	row_monsters_slain_count.text = str(database.monsters_slain_count)
	row_peasants_conscripted_count.text = str(database.peasants_conscripted_count)
	row_fights_retried_count.text = str(Database.fights_retried_count)
