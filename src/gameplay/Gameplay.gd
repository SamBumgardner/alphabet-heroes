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
	enemy.enemy_defeated.connect(combat_sequencer._on_enemy_defeated)
	
	var party_controller = $PartyController as PartyController
	party_controller.party_activated.connect(enemy._on_party_activated)
	
	text_controller.word_changed.connect(party_controller._on_word_changed)
	text_controller.word_activated.connect(party_controller._on_word_activated)
	
	var player_combat_preview = $PlayerCombatPreview as CombatPreview
	party_controller.party_changed.connect(player_combat_preview._on_party_changed)
	
	var enemy_combat_preview = $EnemyCombatPreview as CombatPreview
	enemy.action_changed.connect(enemy_combat_preview._on_action_changed)
	enemy_combat_preview._on_action_changed(enemy.current_action)
	
	var player = $Player as Player
	enemy.enemy_activated.connect(player._on_enemy_activated)
	combat_sequencer.combat_finished.connect(player._on_combat_finished)
	party_controller.party_activated.connect(player._on_party_activated)
	player.player_defeated.connect(combat_sequencer._on_player_defeated)
	
	var tile_text_display = $TileTextDisplay as TileTextDisplay
	text_controller.word_changed.connect(tile_text_display._set_word)
	text_controller.word_denied.connect(tile_text_display._color_denied_text)
	
	# short-term game over handling:
	var developer_only_navigation = $DeveloperOnlyNavigation
	combat_sequencer.gameover_victory_finished.connect(
		developer_only_navigation._on_win_button_pressed
	)
	combat_sequencer.gameover_defeat_finished.connect(
		developer_only_navigation._on_lose_button_pressed
	)
