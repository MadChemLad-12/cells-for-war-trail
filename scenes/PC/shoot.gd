# shootstate.gd
extends State

func enter() -> void:
	print("%s entered shooting" % actor.name)

func handle_input(event: InputEvent) -> void:
	# Handel some clicking input to target enemy
	pass

func process_state(delta: float) -> void:
	signal shoot_requested(shooter: Node, target: Node, weapon: WeaponResource)

func _on_shoot_pressed(target: Node) -> void:
	shoot_requested.emit(actor, target, actor.current_weapon)
