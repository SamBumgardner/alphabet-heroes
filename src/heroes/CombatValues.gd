class_name CombatValues

enum Values {
    ATTACK = 0,
    BLOCK = 1,
    MAGIC = 2,
    HEAL = 3
}

const JOB_VALUES = [
    [1, 0, 0, 0], # Peasant
    [4, 4, 0, 0], # Warrior
    [2, 8, 0, 0], # Knight
    [0, 0, 8, 0], # Mage
    [2, 2, 0, 2], # Priest
]
