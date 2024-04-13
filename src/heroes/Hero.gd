class_name Hero extends RefCounted

var letter : String
var job : Job

func _init(letter_in:String, job_in:Job):
    letter = letter_in
    job = job_in

enum Job {
    WARRIOR = 0,
    KNIGHT = 1,
    MAGE = 2,
    PRIEST = 3,
    PEASANT = 4,
}
