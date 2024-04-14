class_name PartyController extends Node

signal party_changed(new_party:Party)
signal party_activated(party:Party)

@export var hero_repository : HeroRepository;

func _on_word_changed(new_word:String):
	var party = generate_party(new_word)
	party_changed.emit(party)

func _on_word_activated(word:String):
	var party = generate_party(word)
	party_activated.emit(party)

func generate_party(word:String) -> Party:
	if hero_repository == null:
		push_error("PartyController could not find HeroRepository, did not update party")
		return null
		
	return Party.new(hero_repository.get_heroes(word))
