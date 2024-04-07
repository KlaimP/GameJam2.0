extends Node2D

var work := false
var materialGeneration := 2
var energyConsum := 1;
var castle

func _ready():
	castle = EventBus.castle
	EventBus.start_turn.connect(turn)
	work=working()
	
func turn():
	castle.add_materials(materialGeneration)
	if !work:
		work=working()
	
func working() -> bool:
	var _get = castle.take_energy(energyConsum)
	print("Take " + str(energyConsum) + " energy: " + str(_get))
	return _get
