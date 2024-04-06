extends Node2D

var dark := 2
@onready var map = $"../Map"
@onready var artInf = load("res://dark_2.tscn")
@onready var artFutInf = load("res://dark_3.tscn")


var infectedTiles: Array
var futureInfectedTiles: Array



func _ready():
	var maxCount = -10 ** 7
	var maxTile
	for i in map.tiles:
		if i[0] + i[1] + i[2] > maxCount:
			maxCount = i[0] + i[1] + i[2]
			maxTile = Vector3(i[0], i[1], i[2])
	var infectedTile = artInf.instantiate()
	map.tiles[Vector3(maxTile)].add_child(infectedTile)
	map.tiles[Vector3(maxTile)].dark = infectedTile
	infectedTiles.append(map.tiles[Vector3(maxTile)])
	future_infected()
	EventBus.end_turn.connect(infect)

func infect():
	for i in futureInfectedTiles:
		if i.lightPower < dark:
			var infectedTile = artInf.instantiate()
			i.add_child(infectedTile)
			i.dark = infectedTile
			infectedTiles.append(i)
	future_infected()

func future_infected():
	for i in infectedTiles:
		for j in map.find_neighbors(i.tilePosition):
			if j.lightPower < dark:
				var infectedTile = artFutInf.instantiate()
				j.add_child(infectedTile)
				futureInfectedTiles.append(j)

func check_color(tile):
	pass

#func end_turn():
	#for i in futureInfectedTiles:
		#if i.lightPower < dark:
			#var infectedTile = artInf.instantiate()
			#i.add_child(infectedTile)
			#i.dark = infectedTile
			#arr.append(i)
#
#func _ready():
	#EventBus.end_turn.connect(end_turn)
	#infect(map.tiles[Vector3(0, 0, 6)])
#
#func infect(tile):
	#var infectedTile = artInf.instantiate()
	#tile.add_child(infectedTile)
	#tile.dark = infectedTile
	#arr.append(tile)
	#future_infect()
#
#func future_infect():
	#for i in arr:
		#for j in map.find_neighbors(i.tilePosition):
			#if j.lightPower < dark:
				#var futureInfectedTile = artFutInf.instantiate()
				#j.add_child(futureInfectedTile)
				#futureInfectedTiles.append(j)
