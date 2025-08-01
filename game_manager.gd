extends Node

var grid_step: Vector2i = Vector2i(60, 35)  # Assuming hexagons are 64x64 pixels

enum Season {
	Spring,
	Summer,
	Autumn,
	Winter,
}

signal next_turn(current_season: Season)

var current_season: Season = Season.Spring:
	set(new_value):
		current_season = new_value
		next_turn.emit(current_season)

