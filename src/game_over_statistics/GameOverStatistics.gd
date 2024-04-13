extends Control

@onready var database = get_node("/root/Database")

@onready var row_heroes_summoned_count = $Rows/HeroesSummoned/Count
@onready var row_monsters_slain_count = $Rows/MonstersSlain/Count
@onready var row_peasants_constripted_count = $Rows/PeasantsConscripted/Count

func _ready():
	_init_statistics_rows_counts()

func _init_statistics_rows_counts() -> void:
	row_heroes_summoned_count.text = str(database.heroes_summoned_count)
	row_monsters_slain_count.text = str(database.monsters_slain_count)
	row_peasants_constripted_count.text = str(database.peasants_constripted_count)
