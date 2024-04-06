extends Node2D

var levelLight := 1;
var energyConsum := 1;

func _ready():
	working()

func working() -> bool:
	var _energyConsumer = get_parent().get_node("EnergyConsumer")
	var _get = _energyConsumer.get_energy(energyConsum)
	print("Take " + str(energyConsum) + " energy: " + str(_get))
	return _get
