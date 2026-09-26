# MovingState.gd
extends State

func enter() -> void:
	print("%s entered Moving" % actor.name)

func process_state(delta: float) -> void:
	# follow path set by GridManager's move_requested signal
	pass
