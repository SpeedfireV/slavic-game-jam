class_name Bee extends Unit

enum BeeType{
	NORMAL,
	WARRIOR,
	COLLECTOR,
	SUPPORT,
	QUEEN
}

var moves: int = 15
var health: int = 100
var coords: Vector2i:
	set(value):
		coords = value
		global_position = Vector2(value) * Map.grid_step

var bee_name: String = "Zbyszek"
var type := BeeType.NORMAL
var equiped_resources: CollectableResources = CollectableResources.new()

func _input(event):
	if GameManager.selected_bee == self:
		if Input.is_action_just_pressed("move"):
			Map.move_bee(self, GameManager.mouse_on_hex.coords)
