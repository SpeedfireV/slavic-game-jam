class_name Navigator extends Node2D

@onready var navigation_line: Line2D = %NavigationLine
@onready var navigation_cost_label: Label = %NavigationCost
func _ready():
	GameManager.navigator = self

func show_navigation():
	navigation_line.points.clear()
	if GameManager.mouse_on_hex and GameManager.selected_hexagon:
		GameManager.mouse_on_hex.coords
		GameManager.selected_hexagon.coords

		navigation_line.points = [GameManager.selected_hexagon.global_position, GameManager.mouse_on_hex.global_position]
		navigation_cost_label.global_position = GameManager.mouse_on_hex.global_position + Vector2(-navigation_cost_label.size.x / 2, -50)
