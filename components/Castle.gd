extends Node2D

var curMaterials := 10
var maxEnergy := 5
var consumedEnergy := 0
var price := 2

func _ready():
	EventBus.castle = self
	EventBus.start_turn.connect(start_turn)
	EventBus.end_turn.connect(end_turn)

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

func change_labels():
	var energyLabel: Array
	energyLabel.append(consumedEnergy)
	energyLabel.append(maxEnergy)
	EventBus.change_energy_label.emit(energyLabel)
	EventBus.change_materials_label.emit(curMaterials)

func start_turn():
	change_labels()

func end_turn():
	change_labels()
