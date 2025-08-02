class_name Flower extends HexagonResource

@export var energy: int = 0
@export var collect_times: int = 0

@export var can_grow_summer: bool = true
@export var can_grow_fall: bool = true
@export var can_grow_spring: bool = true


func _ready():
	possible_resources.honey = 1
	possible_resources.besswax = 1
	possible_resources.nectar = 1

func get_rand_resource_ammount():
	return randi() % 7 + 1
