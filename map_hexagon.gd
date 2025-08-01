class_name MapHexagon extends Node2D

enum HexagonOrientation {
	Right,
	Left,
	TopLeft,
	TopRight,
	BottomLeft,
	BottomRight
}

enum HexagonType {
	Empty,
	Forest,
	Mountain,
	River,
	Swamp,
	Plain
}

class Neighbours:
	var hexagons: Dictionary[HexagonOrientation, MapHexagon] = {
		HexagonOrientation.Right: null,
		HexagonOrientation.Left: null,
		HexagonOrientation.TopLeft: null,
		HexagonOrientation.TopRight: null,
		HexagonOrientation.BottomLeft: null,
		HexagonOrientation.BottomRight: null
	}
	var left_hexagon: MapHexagon = null
	var right_hexagon: MapHexagon = null
	var top_left_hexagon: MapHexagon = null
	var top_right_hexagon: MapHexagon = null
	var bottom_left_hexagon: MapHexagon = null
	var bottom_right_hexagon: MapHexagon = null

	func all_filled():
		return left_hexagon != null and right_hexagon != null and \
			top_left_hexagon != null and top_right_hexagon != null and \
			bottom_left_hexagon != null and bottom_right_hexagon != null

	func get_not_filled():
		var not_filled: Array[HexagonOrientation] = []
		if left_hexagon == null:
			not_filled.append(HexagonOrientation.Left)
		if right_hexagon == null:
			not_filled.append(HexagonOrientation.Right)
		if top_left_hexagon == null:
			not_filled.append(HexagonOrientation.TopLeft)
		if top_right_hexagon == null:
			not_filled.append(HexagonOrientation.TopRight)
		if bottom_left_hexagon == null:
			not_filled.append(HexagonOrientation.BottomLeft)
		if bottom_right_hexagon == null:
			not_filled.append(HexagonOrientation.BottomRight)
		return not_filled

	func set_hexagon(hexagon: MapHexagon, orientation: HexagonOrientation):
		match orientation:
			HexagonOrientation.Left:
				left_hexagon = hexagon
			HexagonOrientation.Right:
				right_hexagon = hexagon
			HexagonOrientation.TopLeft:
				top_left_hexagon = hexagon
			HexagonOrientation.TopRight:
				top_right_hexagon = hexagon
			HexagonOrientation.BottomLeft:
				bottom_left_hexagon = hexagon
			HexagonOrientation.BottomRight:
				bottom_right_hexagon = hexagon


var neighbours: Neighbours = Neighbours.new()

var coords: Vector2i = Vector2i.ZERO

var hexagon_type: HexagonType = HexagonType.Empty
