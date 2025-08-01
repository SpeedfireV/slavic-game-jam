class_name HexBonus extends HBoxContainer

@onready var bonus_icon: TextureRect = %BonusIcon
@onready var bonus_label: Label = %BonusLabel

@export var value: int = 0


func _ready():
	bonus_label.text = str(value)

