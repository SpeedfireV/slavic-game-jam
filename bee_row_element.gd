class_name BeeRowElement extends PanelContainer



@onready var bee_icon: TextureRect = %BeeIcon
var bee: Bee
var custom_theme: StyleBoxFlat

func _ready():
	custom_theme = get_theme_stylebox("panel").duplicate()
	add_theme_stylebox_override("panel", custom_theme)
	print(bee, GameManager.selected_bee)
	if GameManager.selected_bee == bee and GameManager.selected_bee != null:
		custom_theme.border_color = Color(0xff0000ff)
	else:
		custom_theme.border_color = Color(0xffffffff)

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

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if bee:
			GameManager.selected_bee = bee
			GameManager.navigator.show_navigation()
			GameManager.hud.hex_description.visible = true

func _process(delta):
	if GameManager.selected_bee == bee and GameManager.selected_bee != null:
		custom_theme.border_color = Color(0xff0000ff)
	else:
		custom_theme.border_color = Color(0xffffffff)
