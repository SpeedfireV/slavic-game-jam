extends Node


enum Season {
	Spring,
	Summer,
	Autumn,
	Winter,
}

func _nextSeason():
	match current_season:
		Season.Spring:
			return Season.Summer
		Season.Summer:
			return Season.Autumn
		Season.Autumn:
			return Season.Winter
		Season.Winter:
			return Season.Spring

var collectable_resources := CollectableResources.new()

var navigator: Navigator
var selected_hex: MapHexagon
var mouse_on_hex: MapHexagon:
	set(value):
		mouse_on_hex = value
		navigator.show_navigation()
var selected_bee: Bee
var bees_node: BeesNode

var selected_hexagon: MapHexagon = null:
	set(value):
		if value != null:
			GameManager.hud.show_hex_description(value)
		else:
			GameManager.hud.hex_description.visible = false
		selected_hexagon = value
		hexagon_selected.emit(value)
var hud: Hud

signal next_turn_sig(current_season: Season)
signal hexagon_selected(hexagon: MapHexagon)

var current_season: Season = Season.Spring

func next_turn():
	current_season = _nextSeason()
	next_turn_sig.emit(current_season)


func add_new_unit(unit: Unit):
	unit.global_position = Vector2(unit.current_pos) * Map.grid_step
	bees_node.add_child(unit)
	Map.placed_hexagons[unit.current_pos].unit_on_hex = unit
