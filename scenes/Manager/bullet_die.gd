class_name bullet_die
extends Resource

enum Symbol { BLANK, HIT, HIT_2, PIERCE, FIRE }

@export var faces: Array[Symbol] = [
	Symbol.BLANK, Symbol.BLANK, Symbol.BLANK,
	Symbol.HIT, Symbol.HIT, Symbol.HIT
]

func roll(rng: RandomNumberGenerator) -> Symbol:
	return faces[rng.randi_range(0, faces.size() - 1)]
