#turn manager.gd
extends Node

# Handel phase changes
enum Phase { PLAYER, EVENT, SWARM, ENEMY }
signal phase_changed(new_phase: Phase)
var phase: Phase = Phase.PLAYER

@onready var grid_manager: Node2D = $"../GridManager"
@onready var player_team: Node = $"../../PlayerTeam"
@onready var enemy_team: Node = $"../../EnemyTeam"
@export var bullet_die: bullet_die = preload("res://resources/Manager/bullet_die.tscn")
@export var enemy_die: enemy_die = preload("res://scenes/Manager/enemy_die.tscn")
# These bullets should be saved as a resource file but I dont know how to do that.
# Also all enemies will simpley rolle enemy die so I coudl just stor it here for now. 

# Manage player action count 
func update_action_ui() -> void:
	var max_action_count = player_team.max_action_count
	var remaining = max_action_count - action_counter
	# Need to define some sort of action counter
	if turn_label:
		turn_label.text = "%d/3 actions remaining" % remaining

func end_player_turn():
	phase = Phase.EVENT
	# draw card, then if activated -> Phase.ENEMY, else back to PLAYER

func change_phase(new_phase: Phase) -> void:
	phase = new_phase
	phase_changed.emit(new_phase)

func _check_turn_end() -> void:
	if action_counter >= player_team.max_action_count:
		end_player_turn()

# Is in range is calculated in grid manager
# Resolve damage and Shooting
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

func _on_shoot_requested(shooter: Node, target: Node, weapon: WeaponResource) -> void:
	if action_counter >= player_team.max_action_count:
		return # not enough actions
	if target == null or not target.is_alive():
		return  # invalid target, no cost
	if weapon.current_ammo <= 0:
		return  # out of ammo, no cost
	if not grid_manager.is_in_range(shooter_cell, target_cell, weapon.range):
		return  # out of range, no cost
	
	var shooter_cell = grid_manager.tilemap_layer.local_to_map(shooter.global_position)
	var target_cell = grid_manager.tilemap_layer.local_to_map(target.global_position)
	
	# How do I check if the hex is a valid target as I only want them to be able to shoot their weapon if an enemy is located there.
	
	if not grid_manager.is_in_range(shooter_cell, target_cell, weapon.range):
		print("out of range")
		return
	
	# damage and amo
	var symbols = DiceManager.roll_dice(weapon.dice)
	weapon.current_ammo -= 1
	target.take_damage(resolve_damage(symbols))
	action_counter += 1
	_check_turn_end()
	update_action_ui()

# Run functions
func ready() -> void:
	for pc in player_team.get_childern():
		# For each player character on a shoot request
		pc.shoot_request.connect(_on_shoot_requested)
