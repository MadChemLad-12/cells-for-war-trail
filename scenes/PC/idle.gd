# IdleState.gd
extends State

func enter() -> void:
	print("%s entered Idle" % actor.name)
	# play idle animation, etc.
