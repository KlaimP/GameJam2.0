extends Node2D

var work := false
var levelLight := 1;
var energyConsum := 1;
var castle;


func _ready():
	EventBus.end_turn.connect(start_turn)
	castle = EventBus.castle
	work = working()

func start_turn():
	if !work:
		work=working()

func working() -> bool:
	var _get = castle.take_energy(energyConsum)
	print("Take " + str(energyConsum) + " energy: " + str(_get))
	return _get
