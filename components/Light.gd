extends Node2D

var levelLight := 1;
var energyConsum : int;

func working():
	var _energyConsumer = get_parent().get_node("EnergyConsumer")
	_energyConsumer.get_energy(energyConsum)
	print("Take " + str(energyConsum) + " energy")
