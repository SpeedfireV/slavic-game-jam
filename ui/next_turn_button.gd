class_name NextTurnButton extends Button



func _ready():
	pressed.connect(_on_next_turn_button_pressed)

func _on_next_turn_button_pressed():
	GameManager.next_turn()

func _process(delta):
	disabled = false