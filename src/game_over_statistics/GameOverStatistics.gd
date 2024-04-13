extends Control

@onready var row_heroes_summoned_count = $Rows/HeroesSummoned/Count
@onready var row_monsters_slain_count = $Rows/MonstersSlain/Count
@onready var row_peasants_constripted_count = $Rows/PeasantsConscripted/Count

func _ready():
	_init_statistics_rows_counts()

func _init_statistics_rows_counts() -> void:
	var mock_heroes_summoned = 33
	row_heroes_summoned_count.text = str(mock_heroes_summoned)

	var mock_monsters_slain = 9876
	row_monsters_slain_count.text = str(mock_monsters_slain)

	var mock_peasants_constripted = 777
	row_peasants_constripted_count.text = str(mock_peasants_constripted)
