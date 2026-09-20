extends Node2D

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
