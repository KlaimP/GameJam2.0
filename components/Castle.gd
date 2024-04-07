extends Node2D

var curMaterials := 10
var maxEnergy := 5
var consumedEnergy := 0
var playedTurns = 0

var turnsToWin = 100

var energyConsumers: Array

var lightPower = 2
var tile

func _ready():
	EventBus.castle = self


func light_around():
	tile.change_light(lightPower)
	for neigh in tile.connectedTiles:
		neigh.change_light(lightPower)

func dark_around():
	tile.change_light(-lightPower)
	for neigh in tile.connectedTiles:
		neigh.change_light(-lightPower)


func destroy():
	get_tree().change_scene_to_file("res://loose.tscn")
	print("destroy")


func _process(_delta):
	change_labels()


func add_materials(materials):
	curMaterials += materials


func take_materials(needed_materials):
	if curMaterials - needed_materials < 0:
		return false
	curMaterials -= needed_materials
	return true

func add_energy(value):
	maxEnergy += value

func add_consumer(node):
	energyConsumers.append(node)

func take_energy():
	consumedEnergy = 0
	for consumer in energyConsumers:
		if consumedEnergy + consumer.neededEnergy > maxEnergy: break
		consumedEnergy += consumer.neededEnergy
		consumer.work()

func return_energy(node):
	energyConsumers.erase(node)


func change_labels():
	var energyLabel: Array = []
	energyLabel.append(consumedEnergy)
	energyLabel.append(maxEnergy)
	EventBus.change_energy_label.emit(energyLabel)
	EventBus.change_materials_label.emit(curMaterials)


func start_turn():
	if playedTurns > turnsToWin:
		EventBus.win.emit()
	change_labels()
	light_around()
	take_energy()
	playedTurns += 1
	EventBus.change_turn_label.emit(playedTurns)

func end_turn():
	change_labels()
