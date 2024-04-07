extends Node2D

var energyGeneration := 4
var castle

func _ready():
	castle = EventBus.castle
	work()

func destroy():
	destroyed()
	queue_free()

func work():
	castle.add_energy(energyGeneration)

func destroyed():
	castle.add_energy(-energyGeneration)
