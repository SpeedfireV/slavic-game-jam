class_name NextTurnContainer extends Button



func _ready():
	pressed.connect(_on_next_turn_button_pressed)

func _on_next_turn_button_pressed():
	GameManager.next_turn()
