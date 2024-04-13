class_name HeroRepository extends Node

signal hero_repository_contents_changed(current_repository)

# Array of Dictionaries - one dict for each non-peasant hero job
var _repository : Array

func _init():
    _repository = Array()
    _repository.resize(Hero.Job.size() - 1) # exclude the peasants
    _repository.fill({})

func add(heroes:Array):
    for hero : Hero in heroes:
        _repository[hero.job][hero.letter] = true
    hero_repository_contents_changed.emit(_repository)

func remove(letters:String):
    for letter in letters:
        for dict : Dictionary in _repository:
            dict.erase(letter)
    hero_repository_contents_changed.emit(_repository)

func get_heroes(letters:String) -> Array:
    var result = []
    for letter in letters:
        var hero : Hero = null
        for dict : Dictionary in _repository:
            if dict.find_key(letter):
                hero = dict[letter]
                break;
        if hero == null:
            hero = Hero.new(letter, Hero.Job.PEASANT)
        result.append(hero)
    
    return result
    