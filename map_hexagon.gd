class_name MapHexagon extends Node2D

enum HexagonOrientation {
	Right,
	Left,
	TopLeft,
	TopRight,
	BottomLeft,
	BottomRight
}

static var hexagon_orientation_to_relative_pos: Dictionary[HexagonOrientation, Vector2] = {
	HexagonOrientation.Right: Vector2(GameManager.grid_step.x * 2, 0),
	HexagonOrientation.Left: Vector2(GameManager.grid_step.x * 2, 0),
	HexagonOrientation.TopLeft: Vector2(-GameManager.grid_step.x, -GameManager.grid_step.y * 3),
	HexagonOrientation.TopRight: Vector2(GameManager.grid_step.x,  -GameManager.grid_step.y * 3),
	HexagonOrientation.BottomLeft: Vector2(-GameManager.grid_step.x, GameManager.grid_step.y * 3),
	HexagonOrientation.BottomRight: Vector2(GameManager.grid_step.x, GameManager.grid_step.y)
}

class Neighbours:
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
