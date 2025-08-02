class_name Hud extends CanvasLayer

@onready var hex_description: HexDescription = %HexDescription
@onready var next_turn_button: NextTurnButton = %NextTurnButton
@onready var stats_bar: StatsBar = %StatsBar
@onready var current_season_label: Label = %CurrentSeasonLabel
@onready var new_season_color_rect: ColorRect = %NewSeasonColorRect

func _ready():
	GameManager.hud = self
	GameManager.next_turn_sig.connect(_on_next_turn)

func show_hex_description(hexagon: MapHexagon):
	hex_description.update_info(hexagon)
	hex_description.visible = true
	
func _on_next_turn(current_season: GameManager.Season):
	current_season_label.text = str(GameManager.get_season_name(current_season))

func _animate_to_next_season():
	new_season_color_rect.mouse_filter = Control.MOUSE_FILTER_STOP
	var tween: Tween = create_tween()
	tween.tween_property(new_season_color_rect, "color", Color(0x000000ff), 0.4)
	await get_tree().create_timer(0.4)
	tween.tween_property(new_season_color_rect, "color", Color(0x00000000), 0.4).set_delay(0.4)
	new_season_color_rect.mouse_filter = Control.MOUSE_FILTER_PASS