class_name StatsBar extends MarginContainer


# Lista referencji do Twoich etykiet
@onready var honey_comb_label: Label = %Honeycomb
@onready var beeswax_label: Label = %Beeswax
@onready var nectar_label: Label = %Nectar
@onready var beepollen_label: Label = %Beepollen

# Funkcja do aktualizacji etykiet
func _process(delta: float) -> void:
	honey_comb_label.text = "Honeycomb: " + str(GameManager.collectable_resources.honeycomb)
	beeswax_label.text = "Beeswax: " + str(GameManager.collectable_resources.beeswax)
	nectar_label.text = "Nectar: " + str(GameManager.collectable_resources.nectar)
	beepollen_label.text = "Beepollen: " + str(GameManager.collectable_resources.beepollen)
