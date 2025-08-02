class_name Hud extends CanvasLayer

@onready var hex_description: HexDescription = %HexDescription
@onready var next_turn_button: NextTurnButton = %NextTurnButton
@onready var stats_bar: StatsBar = %StatsBar
@onready var current_season_label: Label = %CurrentSeasonLabel

func _ready():
	GameManager.hud = self

	GameManager.next_turn_sig.connect(_on_next_turn)

func show_hex_description(hexagon: MapHexagon):
	hex_description.update_info(hexagon)
	hex_description.visible = true
	
func _on_next_turn(current_season: GameManager.Season):
	current_season_label.text = str(GameManager.get_season_name(current_season))
