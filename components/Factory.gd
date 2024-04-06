extends Node2D

var work := true
var materialGeneration := 2
var castle

func _ready():
	castle = EventBus.castle
	EventBus.start_turn.connect(turn)
	
func turn():
	castle.add_materials(materialGeneration)
