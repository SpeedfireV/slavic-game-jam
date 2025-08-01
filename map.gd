class_name Map
extends Node2D

@export var map_size: int = 50  # Number of rings

var map_hexagon_scene: PackedScene = preload("res://map_hexagon.tscn")

# Track hexes by position
## In hexagon grid
var placed_hexagons: Dictionary[Vector2i, MapHexagon] = {}

enum HexagonOrientation {
	Right,
	Left,
	TopLeft,
	TopRight,
	BottomLeft,
	BottomRight
}
var grid_step: Vector2 = Vector2(60, 35)  # Assuming hexagons are 64x64 pixels


# Pixel-based direction offsets (pointy-topped hex grid)
var orientation_to_pos: Dictionary[HexagonOrientation, Vector2i] = {
	HexagonOrientation.Right: Vector2i(2, 0),
	HexagonOrientation.Left: Vector2i(-2, 0),
	HexagonOrientation.TopRight: Vector2i(1, -3),
	HexagonOrientation.TopLeft: Vector2i(-1, -3),
	HexagonOrientation.BottomRight: Vector2i(1, 3),
	HexagonOrientation.BottomLeft: Vector2i(-1, 3)
}

func _get_next_rotated_orientation(orientation: HexagonOrientation) -> HexagonOrientation:
	match orientation:
		HexagonOrientation.Right:
			return HexagonOrientation.BottomRight
		HexagonOrientation.BottomRight:
			return HexagonOrientation.BottomLeft
		HexagonOrientation.BottomLeft:
			return HexagonOrientation.Left
		HexagonOrientation.Left:
			return HexagonOrientation.TopLeft
		HexagonOrientation.TopLeft:
			return HexagonOrientation.TopRight
		HexagonOrientation.TopRight:
			return HexagonOrientation.Right

	return orientation  # Fallback, should not happen

func _get_opposite_orientation(orientation: HexagonOrientation) -> HexagonOrientation:
	match orientation:
		HexagonOrientation.Right:
			return HexagonOrientation.Left
		HexagonOrientation.Left:
			return HexagonOrientation.Right
		HexagonOrientation.TopLeft:
			return HexagonOrientation.BottomRight
		HexagonOrientation.TopRight:
			return HexagonOrientation.BottomLeft
		HexagonOrientation.BottomLeft:
			return HexagonOrientation.TopRight
		HexagonOrientation.BottomRight:
			return HexagonOrientation.TopLeft
	return orientation  # Fallback, should not happen

func _ready():
	_generate_map()

func _generate_map():
	var last_pos = Vector2i.ZERO
	var current_rotation = HexagonOrientation.Right
	_add_hex(last_pos)  # Add the center hexagon
	last_pos = Vector2i(2, 0)
	current_rotation = HexagonOrientation.BottomLeft
	for i in range(1, map_size):
		for j in range(i * 6):
			if not placed_hexagons.has(last_pos + orientation_to_pos[_get_next_rotated_orientation(current_rotation)]):
				current_rotation = _get_next_rotated_orientation(current_rotation)
				last_pos += orientation_to_pos[current_rotation]
			else:
				last_pos += orientation_to_pos[current_rotation]
			_add_hex(last_pos)
		last_pos += Vector2i(1, 3)
		current_rotation = HexagonOrientation.BottomLeft
		

func _add_hex(pos: Vector2i):
	var hex: MapHexagon = map_hexagon_scene.instantiate()
	placed_hexagons[pos] = hex
	_check_for_neighbors(hex, pos)
	hex.position = Vector2(pos) * grid_step
	hex.coords = Vector2(pos) * grid_step
	add_child(hex)

	placed_hexagons[pos] = hex

func _check_for_neighbors(hex: MapHexagon, pos: Vector2i):
	for orientation in HexagonOrientation.values():
		var neighbor_pos = pos + orientation_to_pos[orientation]
		if placed_hexagons.has(neighbor_pos):
			var neighbor_hex = placed_hexagons[neighbor_pos]
			hex.neighbours.set_hexagon(neighbor_hex, orientation)
			neighbor_hex.neighbours.set_hexagon(hex, _get_opposite_orientation(orientation))
