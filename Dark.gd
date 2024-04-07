extends Node2D

@onready var map = $"../Map"
@onready var darkScene = load("res://Dark.tscn")
@onready var futureDarkScene = load("res://FutureDark.tscn")

var darkPower: float = 0.1
var darkPowerChange: float = 0.1
var futureInfectChance = 0.3
var infectChance = 0.0

var playedTurns = 0

var infectedTiles: Array
var futureInfectedTiles: Array



func _ready():
	EventBus.dark = self
	EventBus.take_dark.emit(self)
	first_infection()
	future_infected()


func first_infection():
	var maxCount = 0
	var maxTile
	for pos in map.tiles.keys():
		if pos.x + pos.y + pos.z > maxCount:
			maxCount = pos.x + pos.y + pos.z
			maxTile = Vector3(pos.x, pos.y, pos.z)
	infect_tile(map.tiles[Vector3(maxTile)])


func infect():
	if infectedTiles.size() == 0:
		EventBus.win.emit()
	playedTurns += 1
	darkPower = int(playedTurns/10 + 1) * darkPowerChange
	for tile in infectedTiles:
		if tile.lightPower > 0:
			destroy_infection(tile)
	for tile in futureInfectedTiles:
		if tile.lightPower > 0:
			destroy_infection(tile)
	for tile in futureInfectedTiles:
		if tile.lightPower < calculate_dark(tile):
			if randf() < infectChance: continue
			infect_tile(tile)
	var newArr: Array = []
	for tile in futureInfectedTiles:
		if tile.futureDark != null: newArr.append(tile)
	futureInfectedTiles.clear()
	futureInfectedTiles = newArr
	future_infected()

func future_infected():
	for tile in infectedTiles:
		for neigh in tile.connectedTiles:
			if neigh.dark != null: continue
			if neigh.futureDark != null: continue
			if neigh.lightPower < calculate_dark(neigh):
				if randf() > futureInfectChance: continue
				future_infect_tile(neigh)
	EventBus.start_turn.emit()

func destroy_infection(tile):
	if tile.futureDark != null:
		futureInfectedTiles.erase(tile)
		tile.futureDark.queue_free()
		tile.futureDark = null
		return
	if tile.dark != null:
		infectedTiles.erase(tile)
		tile.dark.queue_free()
		tile.dark = null
		return


func calculate_dark(tile) -> float:
	var darkness = 0
	for neig in tile.connectedTiles:
		if neig.dark == null: continue
		darkness += darkPower
	return darkness


func infect_tile(tile):
	if tile.futureDark != null:
		tile.futureDark.queue_free()
		tile.futureDark = null
	if tile.building != null:
		tile.building.destroy()
		tile.building = null
	var infectedTile = darkScene.instantiate()
	tile.add_child(infectedTile)
	tile.dark = infectedTile
	infectedTiles.append(tile)
	tile.set_light(-1)

func future_infect_tile(tile):
	var infectedTile = futureDarkScene.instantiate()
	tile.add_child(infectedTile)
	tile.futureDark = infectedTile
	futureInfectedTiles.append(tile)
