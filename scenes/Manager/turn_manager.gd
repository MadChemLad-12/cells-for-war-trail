extends Node

enum Phase { PLAYER, EVENT, ENEMY }
var phase: Phase = Phase.PLAYER
@onready var grid_manager: Node2D = $"../GridManager"
@onready var player_team: Node = $"../../PlayerTeam"
@onready var enemy_team: Node = $"../../EnemyTeam"

# Manage player action count 
func update_action_ui() -> void:
	var max_player_move = player_team.max_player_move
	var remaining = max_player_move - action_counter
	if turn_label:
		turn_label.text = "%d/3 actions remaining" % remaining

func end_player_turn():
	phase = Phase.EVENT
	# draw card, then if activated -> Phase.ENEMY, else back to PLAYER

# Is in range?
func is_in_range(attacker_cell: Vector2i, target_cell: Vector2i, weapon_range: int) -> bool:
	var attacker_axial = grid_manager.map_to_axial(attacker_cell)
	var target_axial = grid_manager.map_to_axial(target_cell)
	return grid_manager.get_hex_distance(attacker_axial, target_axial) <= weapon_range

# Resolve damage
func resolve_damage_enemy(symbols: Array[enemy_die.Symbol]) -> int:
	var damage := 0
	for s in symbols:
		match s:
			enemy_die.Symbol.HIT: damage += 1
			enemy_die.Symbol.HIT_2: damage += 2
			enemy_die.Symbol.PIERCE: damage += 1 # + ignore armor, handled elsewhere
			enemy_die.Symbol.SPECIAL: damage+=2 # create a future effect where this will be creature dependent
			enemy_die.Symbol.BLANK: pass
	return damage

func resolve_damage_player(symbols: Array[bullet_die.Symbol]) -> int:
	var damage := 0
	for s in symbols:
		match s:
			enemy_die.Symbol.HIT: damage += 1
			enemy_die.Symbol.HIT_2: damage += 2
			enemy_die.Symbol.PIERCE: damage += 1 # + ignore armor, handled elsewhere
			enemy_die.Symbol.BLANK: pass
	return damage
