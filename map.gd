class_name Map
extends Node2D

@export var map_size: int = 5  # Number of rings

var map_hexagon_scene: PackedScene = preload("res://map_hexagon.tscn")
var grid_step: Vector2 = Vector2(60, 35)

# Track hexes by position
var placed_hexagons: Dictionary = {}

enum HexagonOrientation {
	Right,
	Left,
	TopLeft,
	TopRight,
	BottomLeft,
	BottomRight
}

# Pixel-based direction offsets (pointy-topped hex grid)
static var orientation_to_pos: Dictionary = {
	HexagonOrientation.Right: Vector2(120, 0),
	HexagonOrientation.Left: Vector2(-120, 0),
	HexagonOrientation.TopRight: Vector2(60, -105),
	HexagonOrientation.TopLeft: Vector2(-60, -105),
	HexagonOrientation.BottomRight: Vector2(60, 105),
	HexagonOrientation.BottomLeft: Vector2(-60, 105)
}

func _ready():
	_generate_map()
	_assign_neighbors()
	for hex in placed_hexagons.values():
		print(hex.position, " - Neighbors: ", hex.neighbours.hexagons)

func _generate_map():
	var center_pos = Vector2.ZERO
	_add_hex(center_pos)

	for radius in range(1, map_size + 1):
		var pos = center_pos + orientation_to_pos[HexagonOrientation.TopLeft] * radius

		var directions = [
			HexagonOrientation.Right,
			HexagonOrientation.BottomRight,
			HexagonOrientation.BottomLeft,
			HexagonOrientation.Left,
			HexagonOrientation.TopLeft,
			HexagonOrientation.TopRight,
		]

		for dir in directions:
			for nothing in range(radius):
				_add_hex(pos)
				pos += orientation_to_pos[dir]

func _add_hex(pos: Vector2):
	if placed_hexagons.has(pos):
		return

	var hex: MapHexagon = map_hexagon_scene.instantiate()
	hex.position = pos
	hex.coords = pos.round()  # Use rounded pixel position as a "coordinate" key
	add_child(hex)

	placed_hexagons[pos] = hex

func _assign_neighbors():
	for pos in placed_hexagons.keys():
		var hex: MapHexagon = placed_hexagons[pos]

		for orientation in HexagonOrientation.values():
			var offset = orientation_to_pos[orientation]
			var neighbor_pos = pos + offset

			if placed_hexagons.has(neighbor_pos):
				var neighbor: MapHexagon = placed_hexagons[neighbor_pos]
				hex.neighbours.set_hexagon(neighbor, orientation)

