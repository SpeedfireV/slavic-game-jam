class_name Map extends Node2D

@export var map_size: int = 1

var map_hexagon_scene: PackedScene = preload("res://map_hexagon.tscn")

var hexagons: Array[MapHexagon] = []

func _generate_map():
	var outer_hexagons: Array[MapHexagon] = []
	var hexagon: MapHexagon = map_hexagon_scene.instantiate()
	hexagon.position = Vector2.ZERO
	outer_hexagons.append(hexagon)
	add_child(hexagon)
	var new_outer_hexagons: Array[MapHexagon] = []
	for i in range(map_size):
		
		while outer_hexagons.size() > 0:
			var first_outer_hexagon: MapHexagon = outer_hexagons[0]	
			var not_filled_orientations: Array[MapHexagon.HexagonOrientation] = first_outer_hexagon.neighbours.get_not_filled()
			print("Not filled orientations: ", not_filled_orientations)
			for not_filled_orient in not_filled_orientations:
				hexagon = map_hexagon_scene.instantiate()
				hexagon.global_position = first_outer_hexagon.global_position + MapHexagon.hexagon_orientation_to_relative_pos[not_filled_orient]
				new_outer_hexagons.append(hexagon)
				
				first_outer_hexagon.neighbours.set_hexagon(hexagon, not_filled_orient)
				add_child(hexagon)
			outer_hexagons.pop_front()

			
		

		outer_hexagons = new_outer_hexagons

func _ready():
	_generate_map()
	
