class_name PartyController extends Node

signal party_changed(new_party:Party)

@export var hero_repository : HeroRepository;

func _on_word_changed(new_word:String):
	if hero_repository != null:
		var party = Party.new(hero_repository.get_heroes(new_word))
		party_changed.emit(party)
	else:
		push_warning("PartyController could not find HeroRepository, did not update party")
