# StateMachine.gd — one of these lives on each actor (PC/enemy)
class_name StateMachine
extends Node

@export var initial_state: State
var current_state: State
var states: Dictionary = {}

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.actor = get_parent()
	if initial_state:
		current_state = initial_state
		current_state.enter()

func transition_to(state_name: String) -> void:
	if not states.has(state_name):
		push_warning("No state named %s" % state_name)
		return
	if current_state:
		current_state.exit()
	current_state = states[state_name]
	current_state.enter()

func _process(delta: float) -> void:
	if current_state:
		current_state.process_state(delta)

func _unhandled_input(event: InputEvent) -> void:
	if current_state:
		current_state.handle_input(event)
