class_name HexDescription extends PanelContainer

@onready var resource_name_label: Label = %ResourceNameLabel

func update_info(hexagon: MapHexagon):
	resource_name_label.text = hexagon.get_hex_resource_name()

	