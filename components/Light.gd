extends Node2D

var work := false
var levelLight := 1;
var energyConsum := 1;
var castle;


func _ready():
	castle = EventBus.castle
	work = working()

func _process(delta):
	if !work:
		if working():
			work = true

func working() -> bool:
	var _get = castle.take_energy(energyConsum)
	print("Take " + str(energyConsum) + " energy: " + str(_get))
	return _get
