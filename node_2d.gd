class_name Bee extends Node2D

enum BeeType{
	NORMAL,
	WARRIOR,
	COLLECTOR,
	QUEEN
}

var moves: int = 15
var health: int = 100

var type := BeeType.NORMAL
var carried_beepollen:int = 0
var carried_nectar:int = 0
