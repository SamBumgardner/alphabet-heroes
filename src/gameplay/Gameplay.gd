extends Control

@onready var database = get_node("/root/Database")

func _ready():
	database.reset_values()
	
	# wire up connections in code to make them more durable than editor config
	var text_controller = $CombatNodes/TextController as TextController
	var combat_sequencer = $CombatNodes/CombatSequencer as CombatSequencer
	text_controller.word_submitted.connect(combat_sequencer._on_word_submitted)
	combat_sequencer.combat_started.connect(text_controller._on_combat_started)
	combat_sequencer.player_impact.connect(text_controller._on_player_impact)
	combat_sequencer.combat_finished.connect(text_controller._on_combat_finished)
	
	var enemy = $CombatNodes/Enemy as Enemy
	combat_sequencer.combat_finished.connect(enemy._on_combat_finished)
	combat_sequencer.enemy_impact.connect(enemy._on_enemy_impact)
	enemy.enemy_defeated.connect(combat_sequencer._on_enemy_defeated)
	
	var party_controller = $CombatNodes/PartyController as PartyController
	party_controller.party_activated.connect(enemy._on_party_activated)
	
	text_controller.word_changed.connect(party_controller._on_word_changed)
	text_controller.word_activated.connect(party_controller._on_word_activated)
	
	var player_combat_preview = $CombatNodes/PlayerCombatPreview as CombatPreview
	party_controller.party_changed.connect(player_combat_preview._on_party_changed)
	
	var enemy_combat_preview = $CombatNodes/EnemyCombatPreview as CombatPreview
	enemy.action_changed.connect(enemy_combat_preview._on_action_changed)
	enemy_combat_preview._on_action_changed(enemy.current_action)
	
	var player = $CombatNodes/Player as Player
	enemy.enemy_activated.connect(player._on_enemy_activated)
	combat_sequencer.combat_finished.connect(player._on_combat_finished)
	party_controller.party_activated.connect(player._on_party_activated)
	player.player_defeated.connect(combat_sequencer._on_player_defeated)
	
	var tile_text_display = $CombatNodes/TileTextDisplay as TileTextDisplay
	text_controller.word_changed.connect(tile_text_display._set_word)
	text_controller.word_denied.connect(tile_text_display._color_denied_text)
	text_controller.word_submitted.connect(tile_text_display._word_submitted_reaction)
	
	var summoned_hero_previews = $CombatNodes/SummonedHeroPreviews as SummonedHeroPreviews
	party_controller.party_changed.connect(summoned_hero_previews._on_party_changed)
	combat_sequencer.player_windup.connect(summoned_hero_previews._on_player_windup)

	var animated_hero_displayer = $CombatNodes/AnimatedHeroDisplayer as AnimatedHeroDisplayer
	party_controller.party_changed.connect(animated_hero_displayer._on_party_changed)
	summoned_hero_previews.summon_hero_positions.connect(
		animated_hero_displayer._on_summon_hero_positions
	)
	combat_sequencer.player_windup.connect(animated_hero_displayer._on_player_windup)
	combat_sequencer.player_impact.connect(animated_hero_displayer._on_player_impact)

	# short-term game over handling:
	var developer_only_navigation = $CombatNodes/DeveloperOnlyNavigation
	combat_sequencer.gameover_victory_finished.connect(
		developer_only_navigation._on_win_button_pressed
	)
	combat_sequencer.gameover_defeat_finished.connect(
		developer_only_navigation._on_lose_button_pressed
	)
