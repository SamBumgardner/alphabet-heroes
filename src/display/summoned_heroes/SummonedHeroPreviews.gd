class_name SummonedHeroPreviews extends HBoxContainer

static var hero_images : Array = [
	preload("res://assets/art/heroes/single_images/Warrior_Standing.png"),
	preload("res://assets/art/heroes/single_images/Knight_Standing.png"),
	preload("res://assets/art/heroes/single_images/Mage_Standing.png"),
	preload("res://assets/art/heroes/single_images/Priest_Standing.png"),
	preload("res://assets/art/heroes/single_images/Peasant_Standing.png"),
]

@onready var hero_previews : Array = get_children()

func _ready():
	for hero_preview in hero_previews:
		hero_preview.hide()

# when party changes, change which things are visible.
func _on_party_changed(new_party:Party):
	for i in range(hero_previews.size()):
		if i < new_party.heroes.size():
			hero_previews[i].texture = hero_images[new_party.heroes[i].job]
			hero_previews[i].show()
		else:
			hero_previews[i].hide()

# when player windup starts, tell the world that it's time to summon set of characters at position
func _on_player_windup(_duration:float):
	pass #communicate all of the stuff
