extends Node2D

var curMaterials = 10
var maxEnergy = 5
var consumedEnergy = 0

func add_materials(materials):
	curMaterials += materials

func take_materials(needed_materials):
	if needed_materials > curMaterials:
		return false
	return true

func take_energy(needed_energy):
	if needed_energy + consumedEnergy > maxEnergy:
		return false
	return true

func return_energy(towerEnergy):
	consumedEnergy -= towerEnergy

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
