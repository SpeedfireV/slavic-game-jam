extends HBoxContainer


# Lista referencji do Twoich etykiet
@onready var honey_comb_label = $Honeycomb
@onready var beeswax_label = $Beeswax
@onready var nectar_label = $Nectar
@onready var honey_label = $Honey

# Funkcja do aktualizacji etykiet
func _process(delta: float) -> void:
	$Honeycomb.text = "Honeycomb: " + str(GameManager.collectable_resources.honeycomb)
	$Beeswax.text = "Beeswax: " + str(GameManager.collectable_resources.besswax)
	$Nectar.text = "Nectar: " + str(GameManager.collectable_resources.nectar)
	$Honey.text = "Honey: " + str(GameManager.collectable_resources.honey)
