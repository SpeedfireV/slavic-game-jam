class_name Navigator extends Node2D

@onready var navigation_line: Line2D = %NavigationLine
@onready var navigation_cost_label: Label = %NavigationCost

func _ready():
	GameManager.navigator = self

func clear_navigation():
	navigation_line.points = []
	navigation_cost_label.text = ""

func show_navigation():
	navigation_line.points = []
	navigation_cost_label.text = ""
	if GameManager.selected_bee == null:
		return  # No bee selected, nothing to navigate

	if GameManager.mouse_on_hex and GameManager.selected_hexagon:
		var start = GameManager.selected_hexagon.coords
		var goal = GameManager.mouse_on_hex.coords

		var goal_hex = Map.placed_hexagons.get(goal)
		if goal_hex == null or goal_hex.hexagon_type == MapHexagon.HexagonType.Blocade:
			navigation_line.points = []
			navigation_cost_label.text = "🚫Unreachable🚫"
			navigation_cost_label.global_position = GameManager.mouse_on_hex.global_position + Vector2(-navigation_cost_label.size.x / 2, -50)

			return  # 🚫 Don't even try pathfinding

		var path = find_path(start, goal)
		if path.is_empty():
			navigation_cost_label.text = "No path"
			return

		var global_points = path.map(func(coord: Vector2i):
			return Map.placed_hexagons[coord].global_position
		)

		navigation_line.points = global_points
		navigation_cost_label.text = str(path.size() - 1)
		navigation_cost_label.global_position = GameManager.mouse_on_hex.global_position + Vector2(-navigation_cost_label.size.x / 2, -50)

func find_path(start: Vector2i, goal: Vector2i) -> Array[Vector2i]:
	var open_set = [start]
	var came_from: Dictionary = {}
	var g_score: Dictionary = {}
	var f_score: Dictionary = {}

	g_score[start] = 0
	f_score[start] = heuristic(start, goal)

	while open_set.size() > 0:
		open_set.sort_custom(func(a, b): return f_score.get(a, INF) < f_score.get(b, INF))
		var current = open_set[0]

		if current == goal:
			return reconstruct_path(came_from, current)

		open_set.remove_at(0)
		var current_hex = Map.placed_hexagons.get(current)

		for dir in Map.HexagonOrientation.values():
			var neighbor_coords = current + Map.orientation_to_pos[dir]
			var neighbor_hex = Map.placed_hexagons.get(neighbor_coords)

			if neighbor_hex == null:
				continue
			if neighbor_hex.hexagon_type == MapHexagon.HexagonType.Blocade:
				continue  # Skip blocked tiles

			var tentative_g = g_score.get(current, INF) + 1
			if tentative_g < g_score.get(neighbor_coords, INF):
				came_from[neighbor_coords] = current
				g_score[neighbor_coords] = tentative_g
				f_score[neighbor_coords] = tentative_g + heuristic(neighbor_coords, goal)
				if not open_set.has(neighbor_coords):
					open_set.append(neighbor_coords)

	return []  # No path found


func heuristic(a: Vector2i, b: Vector2i) -> int:
	var dx = abs(a.x - b.x)
	var dy = abs(a.y - b.y)
	return max(dy / 3, (abs(dx) + dy / 3) / 2)


func reconstruct_path(came_from: Dictionary, current: Vector2i) -> Array[Vector2i]:
	var total_path: Array[Vector2i] = [current]
	while came_from.has(current):
		current = came_from[current]
		total_path.insert(0, current)
	return total_path
