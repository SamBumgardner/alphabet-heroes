extends Control

@onready var database = get_node("/root/Database")

func _ready():
	database.reset_values()
	
	# wire up connections in code to make them more durable than editor config
	var text_controller = $TextController as TextController
	var combat_sequencer = $CombatSequencer as CombatSequencer
	text_controller.word_submitted.connect(combat_sequencer._on_word_submitted)
	combat_sequencer.combat_started.connect(text_controller._on_combat_started)
	combat_sequencer.player_impact.connect(text_controller._on_player_impact)
	combat_sequencer.combat_finished.connect(text_controller._on_combat_finished)
