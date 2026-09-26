# State.gd — base class every state extends
class_name State
extends Node

var actor: Node  # the PC or enemy this state controls

func enter() -> void:
	pass

func exit() -> void:
	pass

func handle_input(event: InputEvent) -> void:
	pass

func process_state(delta: float) -> void:
	pass
