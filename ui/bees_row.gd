class_name BeesRow extends HBoxContainer

const BEE_ROW_ELEMENT_SCENE: PackedScene = preload("res://bee_row_element.tscn")

func _ready():
	GameManager.bees_row = self

func set_bees(bees: Array[Bee]):
	for child in get_children():
		if child is BeeRowElement:
			child.queue_free()  # Clear existing elements

	for bee in bees:
		var bee_row_element = BEE_ROW_ELEMENT_SCENE.instantiate()
		bee_row_element.set_bee(bee)
		add_child(bee_row_element)

