extends Node2D

var work := true
var energyGeneration := 6
var castle;

func _ready():
	castle = EventBus.castle
	working()

func working():
	castle.add_energy(energyGeneration)
