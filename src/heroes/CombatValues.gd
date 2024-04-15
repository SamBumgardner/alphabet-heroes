class_name CombatValues

enum Values {
	ATTACK = 0,
	BLOCK = 1,
	MAGIC = 2,
	HEAL = 3
}

const JOB_VALUES = [
	[3, 1, 0, 0], # Warrior
	[1, 3, 0, 0], # Knight
	[0, 0, 3, 0], # Mage
	[1, 1, 1, 2], # Priest
	[1, 0, 0, 0], # Peasant
]
