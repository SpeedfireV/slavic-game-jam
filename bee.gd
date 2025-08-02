class_name Bee extends Unit

enum BeeType{
	NORMAL,
	WARRIOR,
	COLLECTOR,
	SUPPORT,
	QUEEN
}

var moves: int = 15
var health: int = 100

var bee_name: String = "Zbyszek"
var type := BeeType.NORMAL
var equiped_resources: CollectableResources = CollectableResources.new()




