class_name Navigator extends Node2D

@onready var navigation_line: Line2D = %NavigationLine

func _ready():
	GameManager.navigator = self

func show_navigation():
	navigation_line.points.clear()
	if GameManager.mouse_on_hex and GameManager.selected_hexagon:
		navigation_line.points = [GameManager.mouse_on_hex.global_position, GameManager.selected_hexagon.global_position]
