class_name Bee extends Unit

enum BeeType{
	NORMAL,
	WARRIOR,
	COLLECTOR,
	SUPPORT,
	QUEEN
}

const BEE_NAMES = [
	"Zbyszek",
	"Ania",
	"Krzysztof",
	"Magda",
	"Janek",
	"Basia",
	"Piotr",
	"Kasia",
	"Mahmud",
]

@export var total_number_of_moves: int = 15
var moves_left: int
var health: int = 100
var coords: Vector2i:
	set(value):
		coords = value
		global_position = Vector2(value) * Map.grid_step

var bee_name: String = BEE_NAMES.pick_random()
var type := BeeType.NORMAL
var equiped_resources: CollectableResources = CollectableResources.new()

func _ready():
	moves_left = total_number_of_moves
	# GameManager.next_turn_sig.connect(_on_next_turn)

func _input(event):
	if GameManager.selected_bee == self:
		if Input.is_action_just_pressed("move"):
			GameManager.navigator.move_bee(self, GameManager.mouse_on_hex.coords)

func add_resources(resources: CollectableResources):
	equiped_resources.beepollen += resources.beepollen
	equiped_resources.honeycomb += resources.honeycomb
	equiped_resources.beeswax += resources.beeswax
	equiped_resources.nectar += resources.nectar
	moves_left -= resources.energy

func give_resources_to_hive():
	GameManager.collectable_resources.beepollen += equiped_resources.beepollen
	GameManager.collectable_resources.honeycomb += equiped_resources.honeycomb
	GameManager.collectable_resources.beeswax += equiped_resources.beeswax
	GameManager.collectable_resources.nectar += equiped_resources.nectar
	equiped_resources = CollectableResources.new()

# func _on_next_turn(next_season: GameManager.Season):
# 	moves_left = total_number_of_moves
# 	if next_season == GameManager.Season.Winter and not Map.placed_hexagons.get(coords).hexagon_type == MapHexagon.HexagonType.Beehive:
# 		die()

# func die():
# 	queue_free()
