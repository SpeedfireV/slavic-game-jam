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
	Flower,
	Beehive,
	Blocade,
	Grass
}

var possible_random_hexagon_types: Array[HexagonType] = [
	HexagonType.Empty,
	HexagonType.Flower,
	HexagonType.Blocade,
	HexagonType.Grass
]

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

	func set_neighbouring_hexagon(hexagon: MapHexagon, orientation: HexagonOrientation):
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

@onready var hexagon_sprite: Sprite2D = %HexSprite
@onready var hexagon_border: Sprite2D = %HexBorder
@onready var hexagon_resource: Sprite2D = %HexResource
@onready var interaction_area: Area2D = %InteractionArea
@onready var flower_particles: CPUParticles2D = %FlowerParticles

var neighbours: Neighbours = Neighbours.new()
var coords: Vector2i = Vector2i.ZERO
var hexagon_type: HexagonType = HexagonType.Empty
var selected: bool = false
var units_on_hex: Array[Unit] = []

var mouse_on_top: bool = false:
	set(new_value):
		mouse_on_top = new_value
		if not selected:
			if mouse_on_top:
				var tween: Tween = create_tween()
				tween.tween_property(hexagon_border, "modulate", Color(0xffff00ff), 0.1) 
			else:
				var tween: Tween = create_tween()
				tween.tween_property(hexagon_border, "modulate", Color(0xffffffff), 0.1)


const OBSTACLES: Array[Texture2D] = [
	preload("res://assets/hexagons/obstacles/big_stone.png"),
	preload("res://assets/hexagons/obstacles/scary_bush.png"),
	preload("res://assets/hexagons/obstacles/lake.png"),
	preload("res://assets/hexagons/obstacles/trees.png")
]

const DEFAULT_HEX_BORDER: Texture2D = preload("res://assets/hexagons/default_hex_border.png")
const ALERT_HEX_BORDER: Texture2D = preload("res://assets/hexagons/alert_hex_border.png")

func _ready():
	if coords == Vector2i.ZERO:
		hexagon_type = HexagonType.Beehive
		var bee = Bees.NORMAL_BEE_SCENE.instantiate()
		bee.coords = coords
		GameManager.add_new_unit(bee)
	else:
		hexagon_type = possible_random_hexagon_types.pick_random()
	if hexagon_type == HexagonType.Blocade:
		hexagon_resource.texture = OBSTACLES[randi() % OBSTACLES.size()]
		hexagon_resource.scale = Vector2(2, 2)
	if hexagon_type == HexagonType.Flower:
		hexagon_resource.texture = Flowers.FLOWER_TEXTURES.pick_random()
		hexagon_resource.scale = Vector2(1.7, 1.7)
		flower_particles.emitting = true
	if hexagon_type == HexagonType.Beehive:
		hexagon_resource.texture = preload("res://assets/hexagons/beehive/beehive.png")
		

	interaction_area.mouse_entered.connect(_on_mouse_entered)
	interaction_area.mouse_exited.connect(_on_mouse_exited)
	GameManager.hexagon_selected.connect(_on_hexagon_selected)

func _input(event):
	if mouse_on_top and Input.is_action_just_pressed("select"):
		_on_hexagon_clicked()

func _process(delta):
	if GameManager.selected_hexagon == self:
		pass # TODO: Implement VFX on selection
func _on_mouse_entered():
	mouse_on_top = true
	GameManager.mouse_on_hex = self

func _on_hexagon_selected(hexagon: MapHexagon):
	if hexagon != self and selected:
		selected = false
		var tween: Tween = create_tween()
		tween.tween_property(hexagon_border, "modulate", Color(0xffffffff), 0.1)

func _on_mouse_exited():
	mouse_on_top = false

func _on_hexagon_clicked():
	GameManager.selected_hexagon = self
	selection_effect()
	
	
func selection_effect():
	var tween: Tween = create_tween()
	selected = true
	tween.tween_property(hexagon_border, "modulate", Color(0xff8100ff), 0.1)


func get_hex_resource_name() -> String:
	match hexagon_type:
		HexagonType.Empty:
			return "Empty"
		HexagonType.Flower:
			return "Flower"
		HexagonType.Beehive:
			return "Beehive"
		HexagonType.Blocade:
			return "Blocade"
		HexagonType.Grass:
			return "Grass"
	return "Unknown"
	
