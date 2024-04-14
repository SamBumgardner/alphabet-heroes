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
	
	var enemy = $Enemy as Enemy
	combat_sequencer.combat_finished.connect(enemy._on_combat_finished)
	combat_sequencer.enemy_impact.connect(enemy._on_enemy_impact)
	
	var party_controller = $PartyController as PartyController
	party_controller.party_activated.connect(enemy._on_party_activated)
	
	text_controller.word_changed.connect(party_controller._on_word_changed)
	text_controller.word_activated.connect(party_controller._on_word_activated)
	
	var player_combat_preview = $PlayerCombatPreview as CombatPreview
	party_controller.party_changed.connect(player_combat_preview._on_party_changed)
	
	var enemy_combat_preview = $EnemyCombatPreview as CombatPreview
	enemy.action_changed.connect(enemy_combat_preview._on_action_changed)
	enemy_combat_preview._on_action_changed(enemy.current_action)
