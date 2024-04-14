class_name SummonedHeroPreviews extends HBoxContainer

@onready var hero_previews : Array = get_children()

func _ready():
	for hero_preview in hero_previews:
		hero_preview.hide()

# when party changes, change which things are visible.
func _on_party_changed(new_party:Party):
	for i in range(hero_previews.size()):
		if i < new_party.heroes.size():
			#change display to match the hero's class
			hero_previews[i].show()
		else:
			hero_previews[i].hide()

# when player windup starts, tell the world that it's time to summon set of characters at position
func _on_player_windup(_duration:float):
	pass #communicate all of the stuff
