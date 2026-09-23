extends Node

var rng := RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()

func roll_dice(dice: Array[bullet_die]) -> Array[bullet_die.Symbol]:
	var results: Array[bullet_die.Symbol] = []
	for die in dice:
		results.append(die.roll(rng))
	return results
