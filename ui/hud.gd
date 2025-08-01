class_name Hud extends CanvasLayer

@onready var hex_description: HexDescription = %HexDescription
@onready var next_turn_button: NextTurnContainer = %NextTurnButton
@onready var stats_bar: StatsBar = %StatsBar

func _ready():
	GameManager.hud = self

func show_hex_description(hexagon: MapHexagon):
	hex_description.update_info(hexagon)
	hex_description.visible = true
	