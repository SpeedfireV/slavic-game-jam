class_name HexDescription extends PanelContainer

@onready var resource_name_label: Label = %ResourceNameLabel
@onready var coordinates_label: Label = %Coords

@onready var nectar_label: Label = %NectarLabel
@onready var nectar_icon: TextureRect = %NectarIcon
@onready var beepollen_label: Label = %BeepollenLabel
@onready var beepollen_icon: TextureRect = %BeepollenIcon

@onready var collect_button: Button = %CollectButton 

var show_info_resources :bool = false

func _ready() -> void:
	GameManager.hexagon_selected.connect(update_info)
	collect_button.pressed.connect(_on_collect_button_pressed)

func update_info(hexagon: MapHexagon):
	if hexagon.hexagon_type == MapHexagon.HexagonType.Flower:
		show_info_resources = true
		resource_name_label.text = hexagon.flower_resource.flower_name
	else:
		show_info_resources = false
		resource_name_label.text = hexagon.get_hex_resource_name()
	
	coordinates_label.text = "(" + str(hexagon.coords.x) + "," + str (hexagon.coords.y / 3) + ")"
	if not hexagon.units_on_hex.has(GameManager.selected_bee) or GameManager.selected_bee == null or hexagon.hexagon_type != MapHexagon.HexagonType.Flower:
		collect_button.visible = false
	else:
		collect_button.visible = true
		if hexagon.flower_resource.possible_resources.energy > GameManager.selected_bee.moves_left:
			collect_button.disabled = true
			collect_button.text = "NOT ENOUGH MOVES"
		else:
			collect_button.disabled = false
			print(hexagon)
			print(hexagon.flower_resource)
			print(hexagon.flower_resource.resource_name, 
				hexagon.flower_resource.flower_name)
			print(hexagon.flower_resource.possible_resources)
			collect_button.text = "[" + str(hexagon.flower_resource.possible_resources.energy) + " ENERGY]" + " COLLECT"


func _process(delta: float) -> void:
	if !show_info_resources:
		nectar_label.visible = false
		nectar_icon.visible = false
		beepollen_label.visible = false
		beepollen_icon.visible = false
	else:
		nectar_label.text = str(GameManager.selected_hexagon.flower_resource.possible_resources.nectar)
		nectar_label.visible = true
		nectar_icon.visible = true
		beepollen_label.text = str(GameManager.selected_hexagon.flower_resource.possible_resources.beepollen)
		beepollen_label.visible = true
		beepollen_icon.visible = true
		
func _on_collect_button_pressed():
	if GameManager.selected_bee.moves_left >= GameManager.selected_hexagon.flower_resource.possible_resources.energy:
		GameManager.selected_bee.add_resources(GameManager.selected_hexagon.flower_resource.possible_resources)
		GameManager.selected_hexagon.collect()
