class_name BeesRow extends VBoxContainer

const BEE_ROW_ELEMENT_SCENE: PackedScene = preload("res://bee_row_element.tscn")

@onready var bee_name: LineEdit = %BeeName
@onready var bees_row: HBoxContainer = %BeesRow

func _ready():
	GameManager.bees_row = self
	GameManager.bee_selected.connect(_on_bee_selected)
	bee_name.text_submitted.connect(_on_new_bee_name_submitted)

func set_bees(bees: Array[Bee]):
	for child in bees_row.get_children():
		if child is BeeRowElement:
			child.queue_free()  # Clear existing elements

	for bee in bees:
		var bee_row_element = BEE_ROW_ELEMENT_SCENE.instantiate()
		bee_row_element.set_bee(bee)
		bees_row.add_child(bee_row_element)

func _process(delta):
	if GameManager.selected_hexagon:
		if GameManager.selected_bee in GameManager.selected_hexagon.units_on_hex:
			bee_name.visible = true
		else:
			bee_name.visible = false


func _on_bee_selected(bee: Bee):
	bee_name.text = bee.bee_name

func _on_new_bee_name_submitted(new_name: String):
	GameManager.selected_bee.bee_name = new_name
