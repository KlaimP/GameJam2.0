extends Node2D

var tile

var work := false
var levelLight := 1;
var energyConsum := 1;
var castle;

var lightPower = 1


func _ready():
	EventBus.start_turn.connect(start_turn)
	castle = EventBus.castle
	work = working()

func destroy():
	castle.return_energy(energyConsum)
	light_around(-1)
	queue_free()

func light_around(value):
	tile.change_light(lightPower * value)
	for neigh in tile.connectedTiles:
		neigh.change_light(lightPower* value)

func start_turn():
	if !work:
		work = working()
		light_around(1)
		
		

func working() -> bool:
	var _get = castle.take_energy(energyConsum)
	print("Take " + str(energyConsum) + " energy: " + str(_get))
	return _get
