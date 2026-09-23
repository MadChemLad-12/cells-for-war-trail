class_name enemy_die
extends Resource

enum Symbol { BLANK, HIT, HIT_2, PIERCE, FIRE, SPECIAL }

@export var faces: Array[Symbol] = [
	Symbol.HIT, Symbol.HIT, Symbol.HIT,
	Symbol.HIT, Symbol.BLANK, Symbol.SPECIAL
]

func roll(rng: RandomNumberGenerator) -> Symbol:
	return faces[rng.randi_range(0, faces.size() - 1)]
