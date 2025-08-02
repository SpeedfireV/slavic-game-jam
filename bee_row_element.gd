class_name BeeRowElement extends PanelContainer



@onready var bee_icon: TextureRect = %BeeIcon
var bee: Bee


func set_bee(_bee: Bee):
	bee = _bee
	# if bee.type == Bee.BeeType.NORMAL:
	# 	bee_icon.texture = load("res://assets/hexagons/bees/normal_bee.png")
	# elif bee.type == Bee.BeeType.WARRIOR:
	# 	bee_icon.texture = preload("res://assets/hexagons/bees/warrior_bee.png")
	# elif bee.type == Bee.BeeType.COLLECTOR:
	# 	bee_icon.texture = preload("res://assets/hexagons/bees/collector_bee.png")
	# elif bee.type == Bee.BeeType.SUPPORT:
	# 	bee_icon.texture = preload("res://assets/hexagons/bees/support_bee.png")
	# elif bee.type == Bee.BeeType.QUEEN:
	# 	bee_icon.texture = preload("res://assets/hexagons/bees/queen_bee.png")
	# else:
	# 	push_error("Unknown bee type: " + str(bee.type))
