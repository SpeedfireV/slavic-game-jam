extends Node


enum Season {
	Spring,
	Summer,
	Autumn,
	Winter,
}

func get_season_name(season: Season) -> String:
	match season:
		Season.Spring:
			return "Spring"
		Season.Summer:
			return "Summer"
		Season.Autumn:
			return "Autumn"
		Season.Winter:
			return "Winter"
		_:
			push_error("Error: Invalid season encountered.")
			return "Unknown Season"

func _next_season_enum() -> Season:
	match current_season:
		Season.Spring:
			return Season.Summer
		Season.Summer:
			return Season.Autumn
		Season.Autumn:
			return Season.Winter
		Season.Winter:
			return Season.Spring
		_:
			push_error("Error: Invalid season encountered.")
			return Season.Spring


var collectable_resources := CollectableResources.new()

var navigator: Navigator
var mouse_on_hex: MapHexagon:
	set(value):
		mouse_on_hex = value
		navigator.show_navigation()
var selected_bee: Bee
var bees_node: BeesNode
var bees_row: BeesRow

var selected_hexagon: MapHexagon = null:
	set(value):
		selected_bee = null
		navigator.clear_navigation()
		var bees_on_hex: Array[Bee] 
		for unit in value.units_on_hex:
			if unit is Bee:
				bees_on_hex.append(unit)
		bees_row.set_bees(bees_on_hex)
		bees_row.set_bees(bees_on_hex)
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
	current_season = _next_season_enum()
	next_turn_sig.emit(current_season)
	hud._animate_to_next_season()

func add_new_unit(unit: Unit):
	unit.global_position = Vector2(unit.current_pos) * Map.grid_step
	bees_node.add_child(unit)
	Map.placed_hexagons[unit.current_pos].units_on_hex.append(unit)
