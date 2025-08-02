class_name HexDescription extends PanelContainer

@onready var resource_name_label: Label = %ResourceNameLabel
@onready var coordinates_label: Label = %Coords

@onready var nectar_label: Label = %NectarLabel
@onready var beepollen_label: Label = %BeepollenLabel

var show_info_resources :bool = true

func update_info(hexagon: MapHexagon):
	if hexagon.hexagon_type == MapHexagon.HexagonType.Flower:
		show_info_resources = true 
	else:
		show_info_resources = false
	
	resource_name_label.text = hexagon.get_hex_resource_name()
	coordinates_label.text = "(" + str(hexagon.coords.x) + "," + str (hexagon.coords.y / 3) + ")"


func _process(delta: float) -> void:
	if show_info_resources:
		nectar_label.text = str(GameManager.collectable_resources.nectar)
		beepollen_label.text = str(GameManager.collectable_resources.beepollen)
