extends Node2D


var materialGeneration := 2
var neededEnergy := 1
var castle

func _ready():
	EventBus.set_light.connect(func(): modulate = Color.DIM_GRAY)
	castle = EventBus.castle
	castle.add_consumer(self)


func destroy():
	castle.return_energy(self)
	queue_free()


func work():
	castle.add_materials(materialGeneration)
	modulate = Color.WHITE

