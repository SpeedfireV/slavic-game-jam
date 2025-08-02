class_name HexDescription extends PanelContainer

@onready var resource_name_label: Label = %ResourceNameLabel
@onready var coordinates_label: Label = %Coords

func update_info(hexagon: MapHexagon):
	resource_name_label.text = hexagon.get_hex_resource_name()
	coordinates_label.text = "(" + str(hexagon.coords.x / 60) + "," + str (hexagon.coords.y / 105) + ")"