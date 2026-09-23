extends Node2D

var hex_width = 64
var hex_height = 58
var hex_size = (hex_width * 2.0 / 3.0 )
@onready var player: Node2D = $"../../PlayerTeam/CharacterBody2D"
var astar = AStar2D.new()
signal move_requested(path: Array[Vector2i])

# Setting up grid map
var tilemap_layer: TileMapLayer
var grid_data: Dictionary = {}

func set_tilemap_layer(layer: TileMapLayer) -> void:
	tilemap_layer = layer
	build_pathfind_graph()

## Axial and Cube conversion
# Convert godot map cell Vector2i to Axial (qr)
func map_to_axial(cell: Vector2i) -> Vector2i: # FLAT-TOPPED Hexes (Odd-X offset)
	# Flat-topped hexes store q along the x-axis, r along the y-axis
	var q = cell.x
	var r = cell.y - (cell.x - (cell.x & 1)) / 2
	return Vector2i(q, r)

# Convert axial (q,r) to cube (q,r,s)
func axial_to_cube(axial: Vector2i) -> Vector3i:
	var q = axial.x
	var r = axial.y
	var s = -q - r
	return Vector3i(q,r,s)

# Calculate distance between two axial hexes using cube math
func get_hex_distance(a_axial: Vector2i, b_axial: Vector2i) -> int:
	var a = axial_to_cube(a_axial)
	var b = axial_to_cube(b_axial)
	return int((abs(a.x -b.x)+abs(a.y-b.y)+abs(a.z-b.z))/2.0)

# Neighbours
func get_hex_neighbours(cell: Vector2i) -> Array[Vector2i]:
	#Flat top hex offsets
	var is_odd = (cell.x & 1) != 0
	if is_odd:
		return [
			Vector2i(cell.x + 1, cell.y), Vector2i(cell.x + 1, cell.y + 1),
			Vector2i(cell.x, cell.y + 1), Vector2i(cell.x - 1, cell.y + 1),
			Vector2i(cell.x - 1, cell.y), Vector2i(cell.x, cell.y - 1),
		]
	else:
		return [
			Vector2i(cell.x + 1, cell.y -1), Vector2i(cell.x + 1, cell.y),
			Vector2i(cell.x, cell.y + 1), Vector2i(cell.x - 1, cell.y),
			Vector2i(cell.x - 1, cell.y -1), Vector2i(cell.x, cell.y - 1),
		]

func _pixel_to_flat_hex(point: Vector2) -> Vector2i:
	var x = point.x / hex_size
	var y = point.y / hex_size
	var q = (2./3 * x)
	var r = (-1./3 * x + sqrt(3)/3 * y)
	return Vector2i(round(q), round(r))

## Path_finding
func get_tile_passable(cell: Vector2i) -> String:
	var tile_data = tilemap_layer.get_cell_tile_data(cell)
	if tile_data:
		var custom_val = tile_data.get_custom_data("Passable")
		if custom_val != null:
			return str(custom_val) # Values can be all enemies_only and blocked
	return "none"

func get_astar_id_for_position(global_pos: Vector2) -> int:
	var cell: Vector2i = tilemap_layer.local_to_map(global_pos)
	
	if cell in grid_data:
		return grid_data[cell]
	return astar.get_closest_point(global_pos)
	
# Build A* Graph based on tiles
func build_pathfind_graph() -> void:
	astar.clear()
	grid_data.clear()
	
	var id = 0
	var used_cells = tilemap_layer.get_used_cells()
	
	# Add points ot A*
	for cell in used_cells:
		grid_data[cell] = id
		astar.add_point(id, tilemap_layer.map_to_local(cell))
		id += 1
		
	# connect to adjacent hex abses on tile possibility
	for cell in used_cells:
		var current_id = grid_data[cell]
		var current_passable = get_tile_passable(cell)
			
		if current_passable == "none":
			continue
		for neighbour in get_hex_neighbours(cell):
			if neighbour in grid_data:
				var neighbour_id = grid_data[neighbour]
				var neighbour_passable = get_tile_passable(neighbour)
				if neighbour_passable != "BLOCKED":
					astar.connect_points(current_id, neighbour_id, false)

## Player click input
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		var cell = _pixel_to_flat_hex(get_global_mouse_position())
		if cell in grid_data and get_tile_passable(cell) != "BLOCKED" and not _is_occupied(cell):
			var path = _get_path_to(cell)
			move_requested.emit(path)
