extends Node


enum Season {
	Spring,
	Summer,
	Autumn,
	Winter,
}

var collectable_resources := CollectableResources.new()

signal next_turn(current_season: Season)

var current_season: Season = Season.Spring:
	set(new_value):
		current_season = new_value
		next_turn.emit(current_season)
