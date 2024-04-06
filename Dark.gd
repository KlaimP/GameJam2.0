extends Node2D

var dark := 2
@onready var map = $"../Map"
@onready var artInf = load("res://dark_2.tscn")
@onready var artFutInf = load("res://dark_3.tscn")


var arr: Array
var futureInfectedTiles: Array

func _ready():
	EventBus.end_turn.connect(future_infect)
	#infect(map.tiles[Vector3(0, 0, 6)])

func infect(tile):
	var infectedTile = artInf.instantiate()
	tile.add_child(infectedTile)
	tile.dark = infectedTile
	arr.append(tile)

func future_infect():
	for i in arr:
		for j in map.find_neighbors(i.tilePosition):
			if j.lightPower < dark:
				var futureInfectedTile = artFutInf.instantiate()
				j.add_child(futureInfectedTile)
				futureInfectedTiles.append(j)
