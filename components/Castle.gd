extends Node2D

var curMaterials := 10
var maxEnergy := 5
var consumedEnergy := 0
var price := 2

func _ready():
	EventBus.castle = self

func add_materials(materials):
	curMaterials += materials

func take_materials(needed_materials):
	if needed_materials > curMaterials:
		return false
	curMaterials-=needed_materials
	return true

func take_energy(needed_energy):
	if needed_energy + consumedEnergy > maxEnergy:
		return false
	consumedEnergy += needed_energy
	return true

func return_energy(towerEnergy):
	consumedEnergy -= towerEnergy

func add_energy(value):
	maxEnergy += value
